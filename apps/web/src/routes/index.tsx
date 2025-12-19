import { createFileRoute } from '@tanstack/react-router';
import React from 'react';
import { Tapling } from '@/components';
import { appConfig, taplingConfig, type TTapling } from '@/environment';
import { getRandomTapling } from '@/lib';

export const Route = createFileRoute('/')({
	component: RouteComponent
});

function RouteComponent() {
	const [tapling, setTapling] = React.useState<TTapling | null>(null);

	React.useEffect(() => {
		const previousTapling = sessionStorage.getItem('previousTapling');
		const previous = previousTapling != null ? (JSON.parse(previousTapling) as TTapling) : null;
		const newTapling = getRandomTapling(previous);
		setTapling(newTapling);
		sessionStorage.setItem('previousTapling', JSON.stringify(newTapling));

		const interval = setInterval(() => {
			setTapling((prev) => {
				if (prev == null) return prev;
				return {
					...prev,
					leftHand: prev.leftHand === 'down' ? 'up' : 'down',
					rightHand: prev.rightHand === 'down' ? 'up' : 'down'
				};
			});
		}, 250);

		return () => clearInterval(interval);
	}, []);

	if (tapling == null) {
		return (
			<div className="flex min-h-screen items-center justify-center bg-[#267DF7]">
				<div style={{ height: taplingConfig.size, width: taplingConfig.size }} />
			</div>
		);
	}

	return (
		<div className="relative flex min-h-screen items-center justify-center bg-[#267DF7]">
			<Tapling
				tapling={tapling}
				style={{ height: taplingConfig.size, width: taplingConfig.size }}
			/>
			<a
				href={appConfig.testflight}
				target="_blank"
				rel="noopener noreferrer"
				className="absolute bottom-12 left-1/2 -translate-x-1/2"
			>
				<img
					src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83&releaseDate=1704067200"
					alt="Download on the App Store"
					className="h-10"
				/>
			</a>
		</div>
	);
}
