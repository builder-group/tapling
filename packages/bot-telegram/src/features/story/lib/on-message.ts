import type { TBotContext } from '@/types';
import { sendConsecutiveBotMessages } from './send-bot-messages';

export async function handleStoryMessage(ctx: TBotContext): Promise<void> {
	const session = ctx.story.session.getSession(ctx);
	if (session == null) {
		return;
	}

	const [isTemplateOk, , template] = ctx.story.loader.getTemplate(session.storyId);
	if (!isTemplateOk) {
		ctx.story.session.end(ctx);
		await ctx.reply('Failed to load story. Session ended.');
		return;
	}

	// Only advance if current position expects a user message
	const expectedMessage = template.messages[session.messageIndex];
	if (expectedMessage?.role !== 'user') {
		return;
	}

	const isFirstMessage = session.messageIndex === 0;
	ctx.story.session.advanceMessage(ctx);

	// Clear chat on first message (user-first scenario)
	if (isFirstMessage) {
		const messageId = ctx.message?.message_id;
		await ctx.history.deleteAll(ctx, messageId != null ? [messageId] : undefined);
	}

	await sendConsecutiveBotMessages(ctx, template);
}
