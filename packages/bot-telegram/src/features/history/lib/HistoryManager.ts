import { tAsync } from 'tuple-result';
import { logger } from '@/environment';
import type { TBotContext } from '@/types';
import type { THistoryMessage } from '../types';

export class HistoryManager {
	public add(ctx: TBotContext, message: THistoryMessage): void {
		if (ctx.session.messageHistory.some((m) => m.messageId === message.messageId)) {
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

	public async deleteAll(ctx: TBotContext, keepMessageIds?: readonly number[]): Promise<void> {
		const chatId = ctx.chat?.id;
		if (chatId == null) {
			return;
		}

		const keepSet = keepMessageIds != null ? new Set(keepMessageIds) : undefined;
		const messagesToDelete: THistoryMessage[] = [];
		const messagesToKeep: THistoryMessage[] = [];

		for (const message of ctx.session.messageHistory) {
			if (keepSet != null && keepSet.has(message.messageId)) {
				messagesToKeep.push(message);
			} else {
				messagesToDelete.push(message);
			}
		}

		await Promise.all(
			messagesToDelete.map((message) => this.deleteMessage(ctx, chatId, message.messageId))
		);

		ctx.session.messageHistory = keepSet != null ? messagesToKeep : [];
	}

	private async deleteMessage(ctx: TBotContext, chatId: number, messageId: number): Promise<void> {
		const [isOk, err] = await tAsync(ctx.api.deleteMessage(chatId, messageId));
		if (!isOk && err != null) {
			logger.warn('history.deleteMessage failed', { chatId, messageId, error: err });
		}
	}
}
