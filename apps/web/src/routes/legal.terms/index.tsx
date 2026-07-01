import { createFileRoute, redirect } from '@tanstack/react-router';
import { appConfig } from '@/environment';

export const Route = createFileRoute('/legal/terms/')({
	beforeLoad: () => {
		throw redirect({ href: appConfig.legal.terms });
	}
});
