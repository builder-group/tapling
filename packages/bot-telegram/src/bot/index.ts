import { appConfig, logger } from '@/environment';
import { bot } from './bot';
import './commands';
import './listeners';

export function startBot() {
	logger.info(`Starting bot (${appConfig.version})...`);
	bot.start();
	logger.info(`Bot (${appConfig.version}) started successfully`);
}
