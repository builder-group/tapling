import { taplingConfig, TTapling } from '@/environment';

export function getRandomItem<T>(array: readonly T[]): T {
	return array[Math.floor(Math.random() * array.length)]!;
}

function isSameTapling(a: TTapling, b: TTapling): boolean {
	return (
		a.fur === b.fur &&
		a.hat === b.hat &&
		a.face === b.face &&
		a.leftHand === b.leftHand &&
		a.rightHand === b.rightHand
	);
}

export function getRandomTapling(previous?: TTapling | null): TTapling {
	let newTapling: TTapling;
	do {
		newTapling = {
			fur: getRandomItem(taplingConfig.parts.fur.available),
			hat: Math.random() > 0.5 ? getRandomItem(taplingConfig.parts.hat.available) : undefined,
			face: getRandomItem(taplingConfig.parts.face.available),
			leftHand: getRandomItem(taplingConfig.parts.hand.available),
			rightHand: getRandomItem(taplingConfig.parts.hand.available)
		};
	} while (previous != null && isSameTapling(newTapling, previous));

	return newTapling;
}
