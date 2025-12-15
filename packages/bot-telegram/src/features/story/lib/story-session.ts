import type { BotContext } from '@/types';

export function startStorySession(ctx: BotContext, storyId: string): void {
	ctx.session.storySession = {
		storyId,
		messageIndex: 0,
		startedAt: new Date().toISOString()
	};
}

export function getStorySession(ctx: BotContext): TStorySession | undefined {
	return ctx.session.storySession;
}

export function advanceMessage(ctx: BotContext): void {
	const session = ctx.session.storySession;
	if (session == null) {
		return;
	}

	session.messageIndex += 1;
}

export function endStorySession(ctx: BotContext): void {
	ctx.session.storySession = undefined;
}

export function addBotMessage(ctx: BotContext, messageId: number): void {
	ctx.session.botMessageIds.push(messageId);
}

export function getBotMessageIds(ctx: BotContext): number[] {
	return ctx.session.botMessageIds;
}

export function clearBotMessages(ctx: BotContext): void {
	ctx.session.botMessageIds = [];
}

export interface TStorySession {
	storyId: string;
	messageIndex: number;
	startedAt: string;
}
