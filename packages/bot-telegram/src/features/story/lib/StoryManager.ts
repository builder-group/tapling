import type { TBotContext } from '@/types';
import type { TStorySession } from '../types';

export class StoryManager {
	public getSession(ctx: TBotContext): TStorySession | undefined {
		return ctx.session.storySession;
	}

	public start(ctx: TBotContext, storyId: string): void {
		ctx.session.storySession = {
			storyId,
			messageIndex: 0,
			startedAt: new Date().toISOString()
		};
	}

	public end(ctx: TBotContext): void {
		ctx.session.storySession = undefined;
	}

	public advanceMessage(ctx: TBotContext): void {
		const session = ctx.session.storySession;
		if (session == null) {
			return;
		}

		session.messageIndex += 1;
	}
}
