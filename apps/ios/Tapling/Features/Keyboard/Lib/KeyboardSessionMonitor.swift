//
//  KeyboardSessionMonitor.swift
//  Tapling
//
//  Created by Benno on 07.12.25.
//

import Foundation
import SwiftData

@MainActor
final class KeyboardSessionMonitor {
    private let modelContext: ModelContext

    init(
        modelContext: ModelContext,
        dataContainerMonitor: DataContainerMonitor,
        processOnStartup: Bool = true
    ) {
        self.modelContext = modelContext

        // Register handler
        dataContainerMonitor.registerHandler(for: "KeyboardSession") {
            [weak self] in
            await self?.processPendingSessions()
        }

        // Process any existing sessions
        if processOnStartup {
            Task { @MainActor in
                await self.processPendingSessions()
            }
        }
    }

    func processPendingSessions() async {
        guard let sessions = fetchPendingSessions(), !sessions.isEmpty else {
            return
        }

        let totals = calculateTotals(from: sessions)
        guard totals.keystrokes > 0 else {
            return
        }

        guard let player = fetchPlayer() else {
            AppLogger.shared.error(
                "KeyboardSessionMonitor: Failed to fetch Player"
            )
            return
        }

        updatePlayer(player, with: totals)
        deleteSessions(sessions)
        try? modelContext.save()
    }

    private func fetchPendingSessions() -> [KeyboardSession]? {
        let descriptor = FetchDescriptor<KeyboardSession>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try? modelContext.fetch(descriptor)
    }

    private func calculateTotals(from sessions: [KeyboardSession]) -> (
        keystrokes: Int, keycaps: Int
    ) {
        var keystrokes = 0
        var keycaps = 0

        for session in sessions {
            // For MVP: 1 keystroke = 1 keycap
            let sessionKeycaps = session.keystrokeCount
            keystrokes += session.keystrokeCount
            keycaps += sessionKeycaps
        }

        return (keystrokes, keycaps)
    }

    private func fetchPlayer() -> Player? {
        let descriptor = FetchDescriptor<Player>()
        return try? modelContext.fetch(descriptor).first
    }

    private func updatePlayer(
        _ player: Player,
        with totals: (keystrokes: Int, keycaps: Int)
    ) {
        player.totalKeystrokes += totals.keystrokes
        player.totalKeycapsEarned += totals.keycaps
        player.currentKeycaps += totals.keycaps

        if player.firstActiveDate == nil {
            player.firstActiveDate = Date()
        }
        player.lastActiveDate = Date()
    }

    private func deleteSessions(_ sessions: [KeyboardSession]) {
        for session in sessions {
            modelContext.delete(session)
        }
    }
}
