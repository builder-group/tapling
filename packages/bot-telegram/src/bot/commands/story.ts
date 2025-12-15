import { tAsync } from 'tuple-result';
import {
	addBotMessage,
	clearBotMessages,
	endStorySession,
	getBotMessageIds,
	getStorySession,
	startStorySession,
	storyLoader
} from '@/features/story';
import { bot } from '../bot';

bot.command('storystart', async (ctx) => {
	const args = ctx.message?.text?.split(' ').slice(1);
	const storyId = args?.[0];
	if (storyId == null) {
		await ctx.reply('Please provide a story ID.');
		return;
	}

	const [areIdsOk, , ids] = storyLoader.getAllIds();
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

	const existingSession = getStorySession(ctx);
	if (existingSession != null) {
		const previousBotMessageIds = getBotMessageIds(ctx);
		for (const messageId of previousBotMessageIds) {
			await tAsync(ctx.api.deleteMessage(chatId, messageId));
		}
		clearBotMessages(ctx);
		endStorySession(ctx);
	}

	const messageId = ctx.message?.message_id;
	if (messageId != null) {
		await tAsync(ctx.api.deleteMessage(chatId, messageId));
	}

	startStorySession(ctx, storyId);

	const reply = await ctx.reply(`
📖 Story started: ${storyId}

Type your first message to begin the conversation.
Use /storyend to stop.

Ready?
`);

	if (reply.message_id != null) {
		addBotMessage(ctx, reply.message_id);
	}
});

bot.command('storyend', async (ctx) => {
	const userSession = getStorySession(ctx);
	if (userSession == null) {
		await ctx.reply('No active story session.');
		return;
	}

	endStorySession(ctx);
	const reply = await ctx.reply('Story session ended.');
	if (reply.message_id != null) {
		addBotMessage(ctx, reply.message_id);
	}
});
