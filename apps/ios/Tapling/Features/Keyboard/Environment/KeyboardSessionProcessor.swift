//
//  KeyboardSessionProcessor.swift
//  Tapling
//
//  Created by Benno on 07.12.25.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
final class KeyboardSessionProcessor {
    static let shared = KeyboardSessionProcessor()

    private var modelContext: ModelContext {
        DataContainer.shared.modelContext
    }

    private init() {}

    func start() {
        Task { @MainActor in
            await self.processPendingSessions()
        }
    }

    func processOnAppActive() {
        Task { @MainActor in
            await self.processPendingSessions()
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
                "KeyboardSessionProcessor: Failed to fetch Player"
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
