import { validateEnvVar } from 'validatenv';
import { zValidator } from 'validation-adapters/zod';
import { z } from 'zod';

const env = validateEnvVar({
	envKey: 'NODE_ENV',
	validator: zValidator(z.enum(['development', 'production', 'local', 'test'])),
	defaultValue: 'development' as const
});

const packageVersion = validateEnvVar({
	envKey: 'npm_package_version',
	// @ts-expect-error -- @rollup/plugin-replace
	value: process.env.npm_package_version,
	validator: zValidator(z.string()),
	defaultValue: '0.0.0'
});

export const appConfig = {
	env,
	packageVersion,
	version: `v${packageVersion}${env.slice(0, 1)}`
};
