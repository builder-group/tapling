import { appConfig } from '@/environment';
import { bot } from '../bot';

bot.command('version', (ctx) => {
	ctx.reply(`Version: ${appConfig.version}`);
});
