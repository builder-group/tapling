export const appConfig = {
	help: {
		discord: 'https://discord.com/invite/w4xE3bSjhQ',
		email: 'support@builder.group',
		mailto: (subject?: string) => {
			const fullSubject = subject ? `[Tapling] ${subject}` : '[Tapling] Support Request';
			return `mailto:support@builder.group?subject=${encodeURIComponent(fullSubject)}`;
		}
	},
	legal: {
		privacy: 'https://builder.group/apps/tapling/legal/privacy',
		terms: 'https://builder.group/apps/tapling/legal/terms'
	},
	appstore: 'https://apps.apple.com/us/app/tapling-type-with-bongo-cat/id6756097345'
};
