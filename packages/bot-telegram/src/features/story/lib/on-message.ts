import { sendWithTypingIndicator } from '@/lib';
import type { TBotContext } from '@/types';
import type { TStoryTemplate } from '.';

export async function handleStoryMessage(ctx: TBotContext): Promise<void> {
	const userSession = ctx.story.session.getSession(ctx);
	if (userSession == null) {
		return;
	}

	ctx.story.session.advanceMessage(ctx);

	const session = ctx.story.session.getSession(ctx);
	if (session == null) {
		return;
	}

	const [isTemplateOk, , template] = ctx.story.loader.getTemplate(userSession.storyId);
	if (!isTemplateOk) {
		ctx.story.session.end(ctx);
		await ctx.reply('Error loading story. Session ended.');
		return;
	}
	await clearChatIfFirstMessage(ctx, session.messageIndex);
	await processConsecutiveBotMessages(ctx, template);

	const finalSession = ctx.story.session.getSession(ctx);
	if (finalSession != null && finalSession.messageIndex >= template.messages.length) {
		await handleStoryComplete(ctx);
	}
}

async function handleStoryComplete(ctx: TBotContext): Promise<void> {
	ctx.story.session.end(ctx);
	await sendWithTypingIndicator(
		ctx,
		'✨ Story complete! Use /storystart to start a new one.',
		5000
	);
}

async function processConsecutiveBotMessages(
	ctx: TBotContext,
	template: TStoryTemplate
): Promise<void> {
	let session = ctx.story.session.getSession(ctx);
	if (session == null) {
		return;
	}

	while (session.messageIndex < template.messages.length) {
		const message = template.messages[session.messageIndex];
		if (message?.role !== 'bot') {
			break;
		}

		const delay = message.delay ?? 0;
		await sendWithTypingIndicator(ctx, message.text, delay);
		ctx.story.session.advanceMessage(ctx);

		const nextSession = ctx.story.session.getSession(ctx);
		if (nextSession == null) {
			break;
		}
		session = nextSession;
	}
}

async function clearChatIfFirstMessage(ctx: TBotContext, messageIndex: number): Promise<void> {
	if (messageIndex !== 1) {
		return;
	}

	const messageId = ctx.message?.message_id;
	await ctx.history.deleteAll(ctx, messageId != null ? [messageId] : undefined);
}
