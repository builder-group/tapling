import type { Middleware } from 'grammy';
import { Message } from 'grammy/types';
import type { TBotContext } from '@/types';
import { HistoryManager } from './lib';
import type { THistoryMessage } from './types';

export function historyMiddleware(): Middleware<TBotContext> {
	const history = new HistoryManager();

	return async (ctx: TBotContext, next) => {
		ctx.history = history;

		// Install transformer to intercept outgoing API calls and add bot messages to history
		// https://grammy.dev/advanced/transformers
		ctx.api.config.use(async (prev, method, payload, signal) => {
			const responseResult = await prev(method, payload, signal);
			if (!responseResult.ok || responseResult.result == null) {
				return responseResult;
			}

			if (isTelegramMessageDto(responseResult.result)) {
				history.add(ctx, messageDtoToHistoryMessage(responseResult.result));
			}

			return responseResult;
		});

		const incomingMessage = ctx.message;
		if (incomingMessage?.message_id != null && incomingMessage.from != null) {
			history.add(ctx, messageToHistoryMessage(incomingMessage));
		}

		await next();
	};
}

function messageToHistoryMessage(message: Message): THistoryMessage {
	return {
		messageId: message.message_id,
		from: {
			id: message.from?.id ?? 0,
			isBot: message.from?.is_bot ?? false,
			firstName: message.from?.first_name,
			username: message.from?.username
		},
		content: message.text
	};
}

function messageDtoToHistoryMessage(dto: TTelegramMessageDto): THistoryMessage {
	return {
		messageId: dto.message_id,
		from: {
			id: dto.from.id,
			isBot: dto.from.is_bot ?? false,
			firstName: dto.from.first_name,
			username: dto.from.username
		},
		content: dto.text
	};
}

function isTelegramMessageDto(value: unknown): value is TTelegramMessageDto {
	return (
		value != null &&
		typeof value === 'object' &&
		'message_id' in value &&
		typeof value['message_id'] === 'number' &&
		'from' in value &&
		value['from'] != null &&
		typeof value['from'] === 'object' &&
		'id' in value['from'] &&
		typeof value['from']['id'] === 'number'
	);
}

interface TTelegramMessageDto {
	message_id: number;
	from: {
		id: number;
		is_bot?: boolean;
		first_name?: string;
		username?: string;
	};
	text?: string;
}
