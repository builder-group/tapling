import { Context, SessionFlavor } from 'grammy';
import type { TStoryFlavor, TStorySession } from '@/features/story';

export interface TSessionData {
	storySession?: TStorySession;
	botMessageIds: number[];
}

export type TBotContext = Context & SessionFlavor<TSessionData> & TStoryFlavor;
