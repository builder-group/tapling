import { tAsync } from 'tuple-result';
import { bot } from '../bot';

bot.command('storystart', async (ctx) => {
	const args = ctx.message?.text?.split(' ').slice(1);
	const storyId = args?.[0];
	if (storyId == null) {
		await ctx.reply('Please provide a story ID.');
		return;
	}

	const [areIdsOk, , ids] = ctx.story.loader.getAllIds();
	if (!areIdsOk) {
		await ctx.reply('Failed to load story IDs. Please try again later.');
		return;
	}

	const validIds = ids;
	if (!validIds.includes(storyId)) {
		await ctx.reply(`
Invalid story ID. Available: ${validIds.join(', ')}

Usage: /storystart [${validIds.join('|')}]
`);
		return;
	}

	const chatId = ctx.chat?.id;
	if (chatId == null) {
		return;
	}

	const existingSession = ctx.story.session.getSession(ctx);
	if (existingSession != null) {
		await ctx.history.deleteAll(ctx);
		ctx.story.session.end(ctx);
	}

	const messageId = ctx.message?.message_id;
	if (messageId != null) {
		await tAsync(ctx.api.deleteMessage(chatId, messageId));
	}

	ctx.story.session.start(ctx, storyId);

	await ctx.reply(`
📖 Story started: ${storyId}

Type your first message to begin the conversation.
Use /storyend to stop.

Ready?
`);
});

bot.command('storyend', async (ctx) => {
	const userSession = ctx.story.session.getSession(ctx);
	if (userSession == null) {
		await ctx.reply('No active story session.');
		return;
	}

	ctx.story.session.end(ctx);
	await ctx.reply('Story session ended.');
});
