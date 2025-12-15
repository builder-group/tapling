import { storyLoader, storySession } from '@/features/chat-story';
import { bot } from '../bot';

bot.command('story:start', async (ctx) => {
	const args = ctx.message?.text?.split(' ').slice(1);
	const storyId = args?.[0] || 'story-1';

	const [areIdsOk, , ids] = storyLoader.getAllIds();
	if (!areIdsOk) {
		await ctx.reply('Failed to load story IDs. Please try again later.');
		return;
	}

	const validIds = ids;
	if (!validIds.includes(storyId)) {
		await ctx.reply(`
Invalid story ID. Available: ${validIds.join(', ')}

Usage: /story:start [${validIds.join('|')}]
`);
		return;
	}

	const userId = ctx.from?.id;
	const chatId = ctx.chat?.id;
	if (userId == null || chatId == null) {
		return;
	}

	const existingSession = storySession.get(userId);
	if (existingSession != null) {
		storySession.end(userId);
	}

	const messageId = ctx.message?.message_id;
	if (messageId != null) {
		await ctx.api.deleteMessage(chatId, messageId);
	}

	storySession.start(userId, storyId);

	await ctx.reply(`
📖 Story started: ${storyId}

Type your first message to begin the conversation.
Use /story:end to stop.

Ready?
`);
});

bot.command('story:end', async (ctx) => {
	const userId = ctx.from?.id;
	if (userId == null) {
		return;
	}

	const userSession = storySession.get(userId);
	if (userSession == null) {
		await ctx.reply('No active story session.');
		return;
	}

	storySession.end(userId);
	await ctx.reply('Story session ended.');
});
