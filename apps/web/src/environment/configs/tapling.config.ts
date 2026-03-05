export const taplingConfig = {
	size: 150,
	parts: {
		fur: {
			available: ['white'] satisfies TTaplingFur[],
			path: {
				base: (fur: TTaplingFur) => getTaplingPath('fur', `${fur}_base`),
				leftHand: (fur: TTaplingFur, hand: TTaplingHand) =>
					getTaplingPath('fur', `${fur}_left-${hand}`),
				rightHand: (fur: TTaplingFur, hand: TTaplingHand) =>
					getTaplingPath('fur', `${fur}_right-${hand}`)
			}
		},
		hat: {
			available: ['banana', 'lil-duck', 'propeller-hat', 'heart'] satisfies TTaplingHat[],
			path: (hat: TTaplingHat) => getTaplingPath('hat', hat)
		},
		face: {
			available: [
				'asia',
				'cute',
				'dead',
				'harry-potter',
				'pilot',
				'pixel-cool'
			] satisfies TTaplingFace[],
			path: (face: TTaplingFace) => getTaplingPath('face', face)
		},
		hand: {
			available: ['down', 'up'] satisfies TTaplingHand[]
		}
	}
};

function getTaplingPath(category: string, name: string): string {
	return `/tapling/${category}/${category}_${name}.svg`;
}

type TTaplingFur = 'mask' | 'white';

type TTaplingHat = 'banana' | 'lil-duck' | 'propeller-hat' | 'heart';

type TTaplingFace = 'asia' | 'cute' | 'dead' | 'harry-potter' | 'pilot' | 'pixel-cool';

type TTaplingHand = 'down' | 'up';

export interface TTapling {
	fur: TTaplingFur;
	hat?: TTaplingHat;
	face: TTaplingFace;
	leftHand: TTaplingHand;
	rightHand: TTaplingHand;
}
