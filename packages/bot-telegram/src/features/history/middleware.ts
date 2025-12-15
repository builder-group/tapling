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

			if (!isMessageDto(responseResult.result)) {
				return responseResult;
			}
			const messageDto = responseResult.result;

			if (!hasChatId(payload)) {
				return responseResult;
			}
			const chatId = payload.chat_id;

			const existing = botMessagesByChat.get(chatId) ?? [];
			botMessagesByChat.set(chatId, [...existing, messageDtoToHistoryMessage(messageDto)]);

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

function hasChatId(payload: unknown): payload is { chat_id: number } {
	return (
		payload != null &&
		typeof payload === 'object' &&
		'chat_id' in payload &&
		typeof (payload as { chat_id: unknown }).chat_id === 'number'
	);
}

function isMessageDto(value: unknown): value is TTelegramMessageDto {
	if (value == null || typeof value !== 'object') {
		return false;
	}

	const obj = value as Record<string, unknown>;
	const messageId = obj['message_id'];
	const from = obj['from'];

	if (typeof messageId !== 'number') {
		return false;
	}

	if (from == null || typeof from !== 'object') {
		return false;
	}

	const fromObj = from as Record<string, unknown>;
	return typeof fromObj['id'] === 'number';
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
