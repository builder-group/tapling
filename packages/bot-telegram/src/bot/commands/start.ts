import { storyLoader } from '@/features/chat-story';
import { bot } from '../bot';

bot.command('start', async (ctx) => {
	const [areIdsOk, , ids] = storyLoader.getAllIds();
	const storyList = areIdsOk && ids.length > 0 ? ids.join(', ') : 'story-1';

	await ctx.reply(`
👋 Welcome!

Available commands:
/story:start [id] - Start a chat story
  Available: ${storyList}
/story:end - End current story session
/version - Show bot version
`);
});
