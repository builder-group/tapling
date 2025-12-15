import type { TBotContext } from '@/types';

// Telegram typing indicators expire after ~5 seconds, so we refresh every 4 seconds
const TYPING_INTERVAL_MS = 4000;

export async function sendWithTypingIndicator(
	ctx: TBotContext,
	text: string,
	delayMs: number = 0
): Promise<{ message_id: number } | undefined> {
	if (delayMs <= 0) {
		const reply = await ctx.reply(text);
		return reply;
	}

	const chatId = ctx.chat?.id;
	if (chatId == null) {
		const reply = await ctx.reply(text);
		return reply;
	}

	const totalIntervals = Math.ceil(delayMs / TYPING_INTERVAL_MS);

	for (let i = 0; i < totalIntervals; i++) {
		await ctx.api.sendChatAction(chatId, 'typing');

		const remainingDelay = delayMs - i * TYPING_INTERVAL_MS;
		const waitTime = Math.min(remainingDelay, TYPING_INTERVAL_MS);

		await new Promise((resolve) => setTimeout(resolve, waitTime));
	}

	const reply = await ctx.reply(text);
	return reply;
}
