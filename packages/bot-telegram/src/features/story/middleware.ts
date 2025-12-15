import type { Middleware } from 'grammy';
import type { TBotContext } from '@/types';
import { StoryLoader, StoryManager } from './lib';

export function storyMiddleware(): Middleware<TBotContext> {
	const loader = new StoryLoader();
	const session = new StoryManager();

	return async (ctx: TBotContext, next) => {
		ctx.story = {
			loader,
			session
		};

		await next();
	};
}
