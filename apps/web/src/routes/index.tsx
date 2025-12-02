import { createFileRoute } from '@tanstack/react-router';
import React from 'react';
import { Tapling } from '@/components';
import { taplingConfig, type TTapling } from '@/environment';
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
			<div className="flex min-h-screen items-center justify-center">
				<div style={{ height: taplingConfig.size, width: taplingConfig.size }} />
			</div>
		);
	}

	return (
		<div className="flex min-h-screen items-center justify-center">
			<Tapling
				tapling={tapling}
				style={{ height: taplingConfig.size, width: taplingConfig.size }}
			/>
		</div>
	);
}
