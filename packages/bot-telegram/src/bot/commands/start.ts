import { storyLoader } from '@/features/story';
import { bot } from '../bot';

bot.command('start', async (ctx) => {
	const [areIdsOk, , ids] = storyLoader.getAllIds();
	const storyList = areIdsOk && ids.length > 0 ? ids.join(', ') : 'story-1';

	await ctx.reply(`
👋 Welcome!

Available commands:
/storystart [id] - Start a chat story
  Available: ${storyList}
/storyend - End current story session
/version - Show bot version
`);
});
