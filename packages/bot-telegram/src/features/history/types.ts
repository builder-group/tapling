import type { HistoryManager } from './lib/history-manager';

export interface THistoryMessage {
	messageId: number;
	from: {
		id: number;
		isBot: boolean;
		firstName?: string;
		username?: string;
	};
}

export interface THistoryFlavor {
	history: HistoryManager;
}
