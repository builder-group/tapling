import { Bot } from 'grammy';
import { logger, telegramConfig } from '@/environment';

export const bot = new Bot(telegramConfig.token);

bot.catch((err) => {
	logger.error('Bot error:', err);
});
