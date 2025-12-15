import { Context, SessionFlavor } from 'grammy';
import type { THistoryFlavor, THistoryMessage } from '@/features/history';
import type { TStoryFlavor, TStorySession } from '@/features/story';

export interface TSessionData {
	storySession?: TStorySession;
	messageHistory: THistoryMessage[];
}

export type TBotContext = Context & SessionFlavor<TSessionData> & TStoryFlavor & THistoryFlavor;
