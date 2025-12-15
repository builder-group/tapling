import { tAsync } from 'tuple-result';
import { logger } from '@/environment';
import type { TBotContext } from '@/types';
import type { THistoryMessage } from '../types';

export class HistoryManager {
	public add(ctx: TBotContext, message: THistoryMessage): void {
		const exists = ctx.session.messageHistory.some((m) => m.messageId === message.messageId);
		if (exists) {
			return;
		}

		ctx.session.messageHistory.push(message);
	}

	public all(ctx: TBotContext): THistoryMessage[] {
		return ctx.session.messageHistory;
	}

	public byRole(ctx: TBotContext, isBot: boolean): THistoryMessage[] {
		return ctx.session.messageHistory.filter((m) => m.from.isBot === isBot);
	}

	public clear(ctx: TBotContext): void {
		ctx.session.messageHistory = [];
	}

	public async deleteAll(ctx: TBotContext): Promise<void> {
		const chatId = ctx.chat?.id;
		if (chatId == null) {
			return;
		}

		for (const message of ctx.session.messageHistory) {
			await this.deleteMessage(ctx, chatId, message.messageId);
		}

		this.clear(ctx);
	}

	public async deleteByRole(ctx: TBotContext, isBot: boolean): Promise<void> {
		const chatId = ctx.chat?.id;
		if (chatId == null) {
			return;
		}

		const remaining: THistoryMessage[] = [];

		for (const message of ctx.session.messageHistory) {
			if (message.from.isBot !== isBot) {
				remaining.push(message);
				continue;
			}

			await this.deleteMessage(ctx, chatId, message.messageId);
		}

		ctx.session.messageHistory = remaining;
	}

	private async deleteMessage(ctx: TBotContext, chatId: number, messageId: number): Promise<void> {
		const [ok, err] = await tAsync(ctx.api.deleteMessage(chatId, messageId));
		if (!ok && err != null) {
			logger.error('history.deleteMessage failed', { chatId, messageId, error: err });
		}
	}
}
