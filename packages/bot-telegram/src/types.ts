import { Context, SessionFlavor } from 'grammy';

export interface TSessionData {
	storySession?: {
		storyId: string;
		messageIndex: number;
		startedAt: string;
	};
	botMessageIds: number[];
}

export type BotContext = Context & SessionFlavor<TSessionData>;
