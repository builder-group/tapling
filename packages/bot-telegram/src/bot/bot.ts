import { FileAdapter } from '@grammyjs/storage-file';
import { Bot, session } from 'grammy';
import { logger, telegramConfig } from '@/environment';
import { historyMiddleware } from '@/features/history';
import { storyMiddleware } from '@/features/story';
import { TBotContext, TSessionData } from '@/types';

export const bot = new Bot<TBotContext>(telegramConfig.token);

bot.use(
	session({
		initial: (): TSessionData => ({
			messageHistory: []
		}),
		storage: new FileAdapter<TSessionData>({
			dirName: telegramConfig.sessionStorageDir
		})
	})
);
bot.use(historyMiddleware());
bot.use(storyMiddleware());

bot.catch((err) => {
	logger.error('Bot error:', err);
});
