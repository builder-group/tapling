//
//  KeyboardSessionMonitor.swift
//  Tapling
//
//  Created by Benno on 07.12.25.
//

import CoreData
import Foundation
import SwiftData
import SwiftUI

@MainActor
final class KeyboardSessionMonitor {
    static let shared = KeyboardSessionMonitor()

    private var modelContext: ModelContext {
        DataContainer.shared.modelContext
    }

    private var isProcessing = false
    private var previousSessionCount = 0
    private var observationTask: Task<Void, Never>?

    private init() {}

    deinit {
        observationTask?.cancel()
    }

    func start() {
        #if DEBUG
            AppLogger.shared.debug(
                "KeyboardSessionMonitor: Starting to observe KeyboardSession changes"
            )
        #endif

        // Use NSPersistentStoreRemoteChange instead of ModelContext.didSave because:
        // - Catches changes from keyboard extension (remote context)
        // - Also catches local changes (same persistent store)
        // - Limitation: Can't filter by model type (notification doesn't tell us which model changed)
        //   We use count-based filtering as a workaround - check if KeyboardSession count changed
        observationTask = Task { @MainActor [weak self] in
            guard let self = self else { return }

            for await _ in NotificationCenter.default.notifications(
                named: .NSPersistentStoreRemoteChange
            ) {
                await self.checkAndProcessSessions()
            }
        }

        Task { @MainActor [weak self] in
            await self?.checkAndProcessSessions()
        }
    }

    private func checkAndProcessSessions() async {
        guard let sessions = fetchPendingSessions() else {
            return
        }

        if sessions.count != previousSessionCount {
            previousSessionCount = sessions.count
            await processPendingSessions()
        }
    }

    func processPendingSessions() async {
        guard !isProcessing else { return }
        guard let sessions = fetchPendingSessions(), !sessions.isEmpty else {
            return
        }

        isProcessing = true
        defer { isProcessing = false }

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

        #if DEBUG
            AppLogger.shared.debug(
                "KeyboardSessionMonitor: Processing \(sessions.count) sessions, totals: \(totals.keystrokes) keystrokes, \(totals.keycaps) keycaps"
            )
        #endif

        updatePlayer(player, with: totals)
        deleteSessions(sessions)
        try? modelContext.save()

        #if DEBUG
            AppLogger.shared.debug(
                "KeyboardSessionMonitor: Processing complete"
            )
        #endif
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
