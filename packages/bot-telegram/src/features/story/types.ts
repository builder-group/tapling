import type { StoryLoader, StoryManager } from './lib';

export interface TStoryFlavor {
	story: {
		loader: StoryLoader;
		session: StoryManager;
	};
}

export interface TStorySession {
	storyId: string;
	messageIndex: number;
}
