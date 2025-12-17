import type { Context } from 'grammy';
import type { StoryLoader, StoryManager } from './lib';

export interface TStoryFlavor {
	story: {
		loader: StoryLoader;
		session: StoryManager;
	};
}

export type TStoryContext = Context & TStoryFlavor;

export interface TStorySession {
	storyId: string;
	messageIndex: number;
	startedAt: string;
}
