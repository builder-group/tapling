import type { TBotContext } from '@/types';
import type { TStorySession } from '../types';

export class StoryManager {
	getSession(ctx: TBotContext): TStorySession | undefined {
		return ctx.session.storySession;
	}

	start(ctx: TBotContext, storyId: string): void {
		ctx.session.storySession = {
			storyId,
			messageIndex: 0,
			startedAt: new Date().toISOString()
		};
	}

	end(ctx: TBotContext): void {
		ctx.session.storySession = undefined;
	}

	advanceMessage(ctx: TBotContext): void {
		const session = ctx.session.storySession;
		if (session == null) {
			return;
		}

		session.messageIndex += 1;
	}

	addBotMessage(ctx: TBotContext, messageId: number): void {
		ctx.session.botMessageIds.push(messageId);
	}

	getBotMessageIds(ctx: TBotContext): number[] {
		return ctx.session.botMessageIds;
	}

	clearBotMessages(ctx: TBotContext): void {
		ctx.session.botMessageIds = [];
	}
}
