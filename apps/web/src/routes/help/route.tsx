import { createFileRoute } from '@tanstack/react-router';
import React from 'react';

export const Route = createFileRoute('/help')({
	component: RouteComponent
});

function RouteComponent() {
	return (
		<div className="flex min-h-screen flex-col items-center justify-center gap-8 p-8">
			<h1 className="text-3xl font-bold">Need Help?</h1>
			<div className="flex flex-col gap-4">
				<a
					href="mailto:support@tapling.app"
					className="rounded-lg bg-blue-600 px-6 py-3 text-center text-white transition-colors hover:bg-blue-700"
				>
					Email Support
				</a>
			</div>
		</div>
	);
}
