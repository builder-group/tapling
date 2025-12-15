import type { Middleware } from 'grammy';
import { StoryLoader, StoryManager } from './lib';
import { TStoryContext } from './types';

export function storyMiddleware(): Middleware<TStoryContext> {
	const loader = new StoryLoader();
	const session = new StoryManager();

	return async (ctx, next) => {
		(ctx as TStoryContext).story = {
			loader,
			session
		};

		await next();
	};
}
