import * as path from 'path';
import { validateEnvVar } from 'validatenv';
import { zValidator } from 'validation-adapters/zod';
import { z } from 'zod';

export const telegramConfig = {
	token: validateEnvVar({
		envKey: 'TELEGRAM_BOT_TOKEN',
		validator: zValidator(z.string())
	}),
	sessionStorageDir: path.join(process.cwd(), '.local', 'sessions')
};
