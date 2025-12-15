import { validateEnvVar } from 'validatenv';
import { zValidator } from 'validation-adapters/zod';
import { z } from 'zod';

export const telegramConfig = {
	token: validateEnvVar({
		envKey: 'TELEGRAM_BOT_TOKEN',
		validator: zValidator(z.string())
	})
};
