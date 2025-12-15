import {
	addBotMessage,
	advanceMessage,
	endStorySession,
	getStorySession,
	storyLoader
} from '@/features/story';
import { sendWithTypingIndicator } from '@/lib';
import { bot } from '../bot';

bot.on('message:text', async (ctx) => {
	const userSession = getStorySession(ctx);
	if (userSession == null) {
		return;
	}

	advanceMessage(ctx);

	const updatedSession = getStorySession(ctx);
	if (updatedSession == null) {
		return;
	}

	const [isTemplateOk, , template] = storyLoader.getTemplate(userSession.storyId);
	if (!isTemplateOk) {
		endStorySession(ctx);
		await ctx.reply('Error loading story. Session ended.');
		return;
	}

	if (updatedSession.messageIndex >= template.messages.length) {
		endStorySession(ctx);
		const reply = await ctx.reply('✨ Story complete! Use /storystart to start a new one.');
		if (reply.message_id != null) {
			addBotMessage(ctx, reply.message_id);
		}
		return;
	}

	const nextMessage = template.messages[updatedSession.messageIndex];
	if (nextMessage == null) {
		return;
	}

	if (nextMessage.role === 'bot') {
		const delay = nextMessage.delay ?? 0;
		const reply = await sendWithTypingIndicator(ctx, nextMessage.text, delay);
		if (reply?.message_id != null) {
			addBotMessage(ctx, reply.message_id);
		}
		advanceMessage(ctx);
	}
});
