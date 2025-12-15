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
		const reply = await ctx.reply('✨ Story complete! Use /storystart to start a new one.');
		if (reply.message_id != null) {
			ctx.story.session.addBotMessage(ctx, reply.message_id);
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
			ctx.story.session.addBotMessage(ctx, reply.message_id);
		}
		ctx.story.session.advanceMessage(ctx);
	}
});
