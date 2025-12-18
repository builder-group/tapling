import type { HistoryManager } from './lib/HistoryManager';

export interface THistoryMessage {
	messageId: number;
	from: {
		id: number;
		isBot: boolean;
		firstName?: string;
		username?: string;
	};
	content?: string;
}

export interface THistoryFlavor {
	history: HistoryManager;
}
