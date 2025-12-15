export class StorySession {
	private sessions = new Map<number, TStorySession>();

	public start(userId: number, storyId: string): void {
		this.sessions.set(userId, {
			userId,
			storyId,
			messageIndex: 0,
			startedAt: new Date()
		});
	}

	public get(userId: number): TStorySession | undefined {
		return this.sessions.get(userId);
	}

	public advanceMessage(userId: number): void {
		const session = this.sessions.get(userId);
		if (session == null) {
			return;
		}

		session.messageIndex += 1;
	}

	public end(userId: number): void {
		this.sessions.delete(userId);
	}
}

export interface TStorySession {
	userId: number;
	storyId: string;
	messageIndex: number;
	startedAt: Date;
}
