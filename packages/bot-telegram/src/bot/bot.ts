import { Bot } from 'grammy';
import { telegramConfig } from '@/environment';

export const bot = new Bot(telegramConfig.token);
