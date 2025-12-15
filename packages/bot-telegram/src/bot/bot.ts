import { FileAdapter } from '@grammyjs/storage-file';
import { Bot, session } from 'grammy';
import { logger, telegramConfig } from '@/environment';
import { BotContext, TSessionData } from '../types';

export const bot = new Bot<BotContext>(telegramConfig.token);

bot.use(
	session({
		initial: (): TSessionData => ({
			botMessageIds: []
		}),
		storage: new FileAdapter<TSessionData>({
			dirName: telegramConfig.sessionStorageDir
		})
	})
);

bot.catch((err) => {
	logger.error('Bot error:', err);
});
