import * as fs from 'fs';
import * as path from 'path';
import { Err, Ok, t, type TResult } from 'tuple-result';
import { logger } from '@/environment';
import { storyConfig } from '../environment';

export class StoryLoader {
	private cache = new Map<string, TStoryTemplate>();

	public getTemplate(storyId: string): TResult<TStoryTemplate, string> {
		const cached = this.cache.get(storyId);
		if (cached != null) {
			return Ok(cached);
		}

		const [isTemplateOk, templateErr, template] = this.loadStoryFromJson(storyId);
		if (!isTemplateOk) {
			return Err(templateErr);
		}

		this.cache.set(storyId, template);
		return Ok(template);
	}

	public getAllIds(): TResult<string[], string> {
		const [isReadOk, readErr, files] = t(() => fs.readdirSync(storyConfig.storiesDir));
		if (!isReadOk) {
			logger.error(`Failed to read story files`, { error: readErr });
			return Err(`Failed to read story files`);
		}

		return Ok(
			files
				.filter((file) => file.endsWith('.json'))
				.map((file) => file.replace(/\.json$/, ''))
				.filter((id) => id.startsWith('story-'))
				.sort()
		);
	}

	private loadStoryFromJson(storyId: string): TResult<TStoryTemplate, string> {
		const filePath = path.join(storyConfig.storiesDir, `${storyId}.json`);
		const [isFileOk, fileErr, fileContent] = t(() => fs.readFileSync(filePath, 'utf-8'));
		if (!isFileOk) {
			logger.error(`Failed to read story file: ${filePath}`, { error: fileErr });
			return Err(`Failed to read story file: ${storyId}`);
		}

		const [isParseOk, parseErr, parsed] = t(() => JSON.parse(fileContent));
		if (!isParseOk) {
			logger.error(`Failed to parse story file: ${filePath}`, { error: parseErr });
			return Err(`Failed to parse story file: ${storyId}`);
		}

		if (!isStoryJson(parsed)) {
			logger.error(`Invalid story file: ${filePath}`, { parsed });
			return Err(`Invalid story file: ${storyId}`);
		}

		return Ok({
			id: storyId,
			messages: this.convertScriptToMessages(parsed.script, parsed.metadata.bot_speaker)
		});
	}

	private convertScriptToMessages(
		script: TStoryJsonScript[],
		botSpeaker: TStoryJsonMetadata['bot_speaker']
	): TStoryMessage[] {
		return script.map((item) => {
			const role = item.speaker === botSpeaker ? 'bot' : 'user';
			const baseDelay = role === 'bot' && item.delay != null ? item.delay : undefined;
			const delay =
				baseDelay != null ? Math.round(baseDelay / storyConfig.speedMultiplier) : undefined;
			return {
				role,
				text: item.text ?? '',
				delay
			};
		});
	}
}

export interface TStoryMessage {
	role: 'user' | 'bot';
	text: string;
	delay?: number;
}

export interface TStoryTemplate {
	id: string;
	messages: TStoryMessage[];
}

interface TStoryJson {
	metadata: TStoryJsonMetadata;
	script: TStoryJsonScript[];
}

interface TStoryJsonMetadata {
	model_version: string;
	prompt_version: string;
	bot_speaker: 'A' | 'B';
}

interface TStoryJsonScript {
	speaker: 'A' | 'B';
	text: string;
	delay?: number;
}

function isStoryJson(value: unknown): value is TStoryJson {
	return typeof value === 'object' && value != null && 'metadata' in value && 'script' in value;
}
