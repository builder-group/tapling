import { createFileRoute } from '@tanstack/react-router';
import { appConfig } from '@/environment';

export const Route = createFileRoute('/')({
	beforeLoad: () => {
		throw Route.redirect({ href: appConfig.appstore });
	},
	component: () => null
});
