import { storyLoader, storySession } from '@/features/chat-story';
import { sendWithTypingIndicator } from '@/lib';
import { bot } from '../bot';

bot.on('message:text', async (ctx) => {
	const userId = ctx.from?.id;
	if (userId == null) {
		return;
	}

	const userSession = storySession.get(userId);
	if (userSession == null) {
		return;
	}

	storySession.advanceMessage(userId);

	const updatedSession = storySession.get(userId);
	if (updatedSession == null) {
		return;
	}

	const [isTemplateOk, , template] = storyLoader.getTemplate(userSession.storyId);
	if (!isTemplateOk) {
		storySession.end(userId);
		await ctx.reply('Error loading story. Session ended.');
		return;
	}

	if (updatedSession.messageIndex >= template.messages.length) {
		storySession.end(userId);
		await ctx.reply('✨ Story complete! Use /story:start to start a new one.');
		return;
	}

	const nextMessage = template.messages[updatedSession.messageIndex];
	if (nextMessage == null) {
		return;
	}

	if (nextMessage.role === 'bot') {
		const delay = nextMessage.delay ?? 0;
		await sendWithTypingIndicator(ctx, nextMessage.text, delay);
		storySession.advanceMessage(userId);
	}
});
