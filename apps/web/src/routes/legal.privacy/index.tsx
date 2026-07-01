import { createFileRoute, redirect } from '@tanstack/react-router';
import { appConfig } from '@/environment';

export const Route = createFileRoute('/legal/privacy/')({
	beforeLoad: () => {
		throw redirect({ href: appConfig.legal.privacy });
	}
});
