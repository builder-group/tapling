import dotenv from 'dotenv';

// Load .env for app config
const nodeEnv = process.env['NODE_ENV'] ?? 'local';
dotenv.config({ path: `.env.${nodeEnv}` });
console.log(`Loaded dotenv from '.env.${nodeEnv}'.`);

(async () => {
	const { startBot } = await import('./src');

	startBot();
})().catch((e) => {
	console.error('Failed to run server by exception: ', e);
});
