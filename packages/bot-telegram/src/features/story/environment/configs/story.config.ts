import * as path from 'path';

export const storyConfig = {
	storiesDir: path.join(process.cwd(), 'public', 'stories'),
	/**
	 * Speed multiplier for story playback.
	 * Delays are divided by this value (lower = slower, higher = faster).
	 * - 1 / 2.5 = 40% speed (slowed down by 2.5x, default for slow writers)
	 * - 1.0 = 100% speed (normal)
	 * - 1.5 = 150% speed (1.5x faster)
	 */
	speedMultiplier: 1 / 2.5
};
