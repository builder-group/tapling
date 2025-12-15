import type { Context } from 'grammy';

// Telegram typing indicators expire after ~5 seconds, so we refresh every 4 seconds
const TYPING_INTERVAL_MS = 4000;

export async function sendWithTypingIndicator(
	ctx: Context,
	text: string,
	delayMs: number = 0
): Promise<void> {
	if (delayMs <= 0) {
		await ctx.reply(text);
		return;
	}

	const chatId = ctx.chat?.id;
	if (chatId == null) {
		await ctx.reply(text);
		return;
	}

	const totalIntervals = Math.ceil(delayMs / TYPING_INTERVAL_MS);

	for (let i = 0; i < totalIntervals; i++) {
		await ctx.api.sendChatAction(chatId, 'typing');

		const remainingDelay = delayMs - i * TYPING_INTERVAL_MS;
		const waitTime = Math.min(remainingDelay, TYPING_INTERVAL_MS);

		await new Promise((resolve) => setTimeout(resolve, waitTime));
	}

	await ctx.reply(text);
}
