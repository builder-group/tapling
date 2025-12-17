import type { Middleware } from 'grammy';
import type { TBotContext } from '@/types';
import { HistoryManager } from './lib';
import type { THistoryMessage } from './types';

export function historyMiddleware(): Middleware<TBotContext> {
	const history = new HistoryManager();
	const botMessagesByChat = new Map<number, THistoryMessage[]>();

	return async (ctx: TBotContext, next) => {
		ctx.history = history;

		// Install transformer to intercept outgoing API calls and capture bot messages.
		// Messages are stored in botMessagesByChat and processed after next() completes.
		// https://grammy.dev/advanced/transformers
		ctx.api.config.use(async (prev, method, payload, signal) => {
			const responseResult = await prev(method, payload, signal);
			if (!responseResult.ok || responseResult.result == null) {
				return responseResult;
			}

			if (!isTelegramMessageDto(responseResult.result)) {
				return responseResult;
			}
			const messageDto = responseResult.result;

			if (!hasChatId(payload)) {
				return responseResult;
			}
			const chatId = payload.chat_id;

			let messages = botMessagesByChat.get(chatId);
			if (messages == null) {
				messages = [];
				botMessagesByChat.set(chatId, messages);
			}
			messages.push(messageDtoToHistoryMessage(messageDto));

			return responseResult;
		});

		const incomingMessage = ctx.message;
		if (incomingMessage?.message_id != null && incomingMessage.from != null) {
			const message = messageDtoToHistoryMessage({
				message_id: incomingMessage.message_id,
				from: incomingMessage.from
			});
			history.add(ctx, message);
		}

		await next();

		const chatId = ctx.chat?.id;
		if (chatId == null) {
			return;
		}

		const botMessages = botMessagesByChat.get(chatId);
		if (botMessages == null) {
			return;
		}

		const sessionMessageIds = new Set(ctx.session.messageHistory.map((m) => m.messageId));
		for (const message of botMessages) {
			if (!sessionMessageIds.has(message.messageId)) {
				history.add(ctx, message);
			}
		}

		botMessagesByChat.delete(chatId);
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
		}
	};
}

function hasChatId(value: unknown): value is { chat_id: number } {
	return (
		value != null &&
		typeof value === 'object' &&
		'chat_id' in value &&
		typeof value.chat_id === 'number'
	);
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
}
