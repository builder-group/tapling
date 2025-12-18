import { sendConsecutiveBotMessages } from '@/features/story';
import { bot } from '../bot';

bot.command('storystart', async (ctx) => {
	const args = ctx.message?.text?.split(' ').slice(1);
	const storyId = args?.[0];
	if (storyId == null) {
		await ctx.reply('Please provide a story ID.');
		return;
	}

	const [areIdsOk, , ids] = ctx.story.loader.getAllIds();
	if (!areIdsOk) {
		await ctx.reply('Failed to load story IDs.');
		return;
	}

	if (!ids.includes(storyId)) {
		await ctx.reply(`
Invalid story ID. Available: ${ids.join(', ')}

Usage: /storystart [${ids.join('|')}]
`);
		return;
	}

	// End existing session if it exists
	const existingSession = ctx.story.session.getSession(ctx);
	if (existingSession != null) {
		ctx.story.session.end(ctx);
	}

	const [isTemplateOk, , template] = ctx.story.loader.getTemplate(storyId);
	if (!isTemplateOk) {
		await ctx.reply('Failed to load story.');
		return;
	}
	const botStartsFirst = template.messages[0]?.role === 'bot';

	// Start new session
	ctx.story.session.start(ctx, storyId);

	const message = await ctx.reply(`📖 Story started: ${storyId}

${botStartsFirst ? 'Bot will start in a few seconds...' : 'Type your first message to begin.'}

Use /storyend to stop.
`);
	await ctx.history.deleteAll(ctx, [message.message_id]);

	if (botStartsFirst) {
		await sendConsecutiveBotMessages(ctx, template, {
			delay: 5000,
			// Clear chat on first message (bot-first scenario)
			clear: true
		});
	}
});

bot.command('storyend', async (ctx) => {
	const session = ctx.story.session.getSession(ctx);
	if (session == null) {
		await ctx.reply('No active story session.');
		return;
	}

	ctx.story.session.end(ctx);
	await ctx.reply(`🔚 Story ended.

Use /storystart to start a new one.
`);
});
