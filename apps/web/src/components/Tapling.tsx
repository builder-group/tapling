import React from 'react';
import { taplingConfig, type TTapling } from '@/environment';
import { cn } from '@/lib';

export const Tapling: React.FC<TTaplingProps> = (props) => {
	const {
		tapling: { fur, leftHand, rightHand, face, hat },
		className,
		...divProps
	} = props;

	const { basePath, leftHandPath, rightHandPath, facePath, hatPath } = React.useMemo(() => {
		return {
			basePath: taplingConfig.parts.fur.path.base(fur),
			leftHandPath: taplingConfig.parts.fur.path.leftHand(fur, leftHand),
			rightHandPath: taplingConfig.parts.fur.path.rightHand(fur, rightHand),
			facePath: taplingConfig.parts.face.path(face),
			hatPath: hat != null ? taplingConfig.parts.hat.path(hat) : null
		};
	}, [fur, leftHand, rightHand, face, hat]);

	return (
		<div className={cn('relative inline-block', className)} {...divProps}>
			{/* Base layer */}
			<img src={basePath} alt="Tapling base" className="absolute inset-0 h-full w-full" />

			{/* Left hand layer */}
			<img src={leftHandPath} alt="Tapling left hand" className="absolute inset-0 h-full w-full" />

			{/* Face layer */}
			<img
				src={facePath}
				alt={`Tapling face: ${face}`}
				className="absolute inset-0 h-full w-full"
			/>

			{/* Hat layer */}
			{hatPath != null && (
				<img src={hatPath} alt={`Tapling hat: ${hat}`} className="absolute inset-0 h-full w-full" />
			)}

			{/* Right hand layer */}
			<img
				src={rightHandPath}
				alt="Tapling right hand"
				className="absolute inset-0 h-full w-full"
			/>
		</div>
	);
};

interface TTaplingProps extends React.HTMLAttributes<HTMLDivElement> {
	tapling: TTapling;
}
