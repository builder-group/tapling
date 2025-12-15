import { sendWithTypingIndicator } from '@/lib';
import { bot } from '../bot';

bot.on('message:text', async (ctx) => {
	const userSession = ctx.story.session.getSession(ctx);
	if (userSession == null) {
		return;
	}

	ctx.story.session.advanceMessage(ctx);

	const updatedSession = ctx.story.session.getSession(ctx);
	if (updatedSession == null) {
		return;
	}

	const [isTemplateOk, , template] = ctx.story.loader.getTemplate(userSession.storyId);
	if (!isTemplateOk) {
		ctx.story.session.end(ctx);
		await ctx.reply('Error loading story. Session ended.');
		return;
	}

	if (updatedSession.messageIndex >= template.messages.length) {
		ctx.story.session.end(ctx);
		await ctx.reply('✨ Story complete! Use /storystart to start a new one.');
		return;
	}

	const nextMessage = template.messages[updatedSession.messageIndex];
	if (nextMessage == null) {
		return;
	}

	// Clear chat after first message is sent and visible
	// We can't clear before because Telegram shows Start button for bots if history is empty (not text input)
	if (updatedSession.messageIndex === 1) {
		await ctx.history.deleteAll(
			ctx,
			ctx.message?.message_id != null ? [ctx.message?.message_id] : undefined
		);
	}

	if (nextMessage.role === 'bot') {
		const delay = nextMessage.delay ?? 0;
		await sendWithTypingIndicator(ctx, nextMessage.text, delay);
		ctx.story.session.advanceMessage(ctx);
	}
});
