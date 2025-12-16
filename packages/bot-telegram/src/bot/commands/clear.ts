import { bot } from '../bot';

bot.command('clear', async (ctx) => {
	await ctx.history.deleteAll(ctx);
	await ctx.reply('Chat cleared! Delete this message to have a blank slate.');
});
