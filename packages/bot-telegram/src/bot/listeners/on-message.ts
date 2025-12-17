import { handleStoryMessage } from '@/features/story';
import { bot } from '../bot';

bot.on('message:text', async (ctx) => {
	await handleStoryMessage(ctx);
});
