import * as fs from 'fs';
import { join } from 'path';
import { Err, mapErr, Ok, t, type TResult } from 'tuple-result';
import { storyConfig } from '../environment';

export class StoryLoader {
	private cache = new Map<string, TStoryTemplate>();

	public getTemplate(storyId: string): TResult<TStoryTemplate, Error> {
		const cached = this.cache.get(storyId);
		if (cached != null) {
			return Ok(cached);
		}

		const jsonPath = join(storyConfig.dataDir, `${storyId}.json`);

		if (!fs.existsSync(jsonPath)) {
			return Err(new Error(`Story file not found: ${storyId}.json`));
		}

		const templateResult = loadStoryFromJson(storyId);
		if (templateResult[0] === false) {
			return templateResult;
		}

		const template = templateResult[2];
		this.cache.set(storyId, template);
		return Ok(template);
	}

	public getAllIds(): TResult<string[], Error> {
		const readResult = t(() => fs.readdirSync(storyConfig.dataDir));
		if (readResult[0] === false) {
			return mapErr(readResult, (err) => (err instanceof Error ? err : new Error(String(err))));
		}

		const files = readResult[2];
		const storyIds = files
			.filter((file) => file.endsWith('.json'))
			.map((file) => file.replace(/\.json$/, ''))
			.filter((id) => id.startsWith('story-'))
			.sort();

		return Ok(storyIds);
	}
}

function parseJsonMessage(msg: TStoryMessage): TStoryMessage {
	const message: TStoryMessage = {
		role: msg.role,
		text: msg.text || ''
	};

	if (msg.role === 'bot' && msg.delay != null) {
		message.delay = msg.delay;
	}

	return message;
}

function loadStoryFromJson(storyId: string): TResult<TStoryTemplate, Error> {
	const filePath = join(storyConfig.dataDir, `${storyId}.json`);

	const readResult = t(() => fs.readFileSync(filePath, 'utf-8'));
	if (readResult[0] === false) {
		const error = readResult[1] instanceof Error ? readResult[1] : new Error(String(readResult[1]));
		return Err(error) as TResult<TStoryTemplate, Error>;
	}

	const jsonContent = readResult[2];
	const parseResult = t(() => JSON.parse(jsonContent));
	if (parseResult[0] === false) {
		const error =
			parseResult[1] instanceof Error ? parseResult[1] : new Error(String(parseResult[1]));
		return Err(error) as TResult<TStoryTemplate, Error>;
	}

	const parsed = parseResult[2];
	const messages: TStoryMessage[] = (parsed.messages || []).map(parseJsonMessage);

	return Ok({
		id: storyId,
		messages
	});
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
