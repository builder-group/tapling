import { sendWithTypingIndicator } from '@/lib';
import type { TBotContext } from '@/types';
import type { TStoryTemplate } from './StoryLoader';

export async function sendConsecutiveBotMessages(
	ctx: TBotContext,
	template: TStoryTemplate,
	options: TSendBotMessagesOptions = {}
): Promise<void> {
	const { delay = 0, clear = false } = options;

	const session = ctx.story.session.getSession(ctx);
	if (session == null) {
		return;
	}

	let isFirstMessage = true;
	while (session.messageIndex < template.messages.length) {
		const message = template.messages[session.messageIndex];
		if (message?.role !== 'bot') {
			break;
		}

		const sentMessage = await sendWithTypingIndicator(
			ctx,
			message.text,
			(message.delay ?? 0) + delay
		);

		if (sentMessage != null && clear && isFirstMessage) {
			await ctx.history.deleteAll(ctx, [sentMessage.message_id]);
			isFirstMessage = false;
		}

		ctx.story.session.advanceMessage(ctx);
	}

	// Check if story is complete
	if (session.messageIndex >= template.messages.length) {
		ctx.story.session.end(ctx);
		await ctx.reply(`✨ Story complete!

Use /storystart to start a new one.
`);
	}
}

interface TSendBotMessagesOptions {
	delay?: number;
	clear?: boolean;
}
