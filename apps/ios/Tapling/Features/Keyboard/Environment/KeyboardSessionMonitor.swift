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

final class KeyboardSessionMonitor {
    static let shared = KeyboardSessionMonitor()

    @MainActor
    private var modelContext: ModelContext {
        DataContainer.shared.modelContext
    }

    private var isProcessing = false
    private var observationTask: Task<Void, Never>?

    private init() {}

    deinit {
        observationTask?.cancel()
    }

    func start() {
        AppLogger.shared.debug(
            "KeyboardSessionMonitor: Starting to observe KeyboardSession changes"
        )

        // Observe remote changes from keyboard extension
        // Note: This fires for ALL model changes in the shared store
        // TODO: Filter by model type (KeyboardSession)
        observationTask = Task { @MainActor in
            for await _ in NotificationCenter.default.notifications(
                named: .NSPersistentStoreRemoteChange
            ) {
                await processPendingSessions()
            }
        }

        // Process any existing pending sessions on startup
        Task { @MainActor in
            await processPendingSessions()
        }
    }

    @MainActor
    func processPendingSessions() async {
        guard !isProcessing else { return }

        // Fetch sessions that are:
        // 1. Not yet processed (processedAt == nil)
        // 2. Completed (endDate != nil)
        guard let sessions = fetchCompletedUnprocessedSessions(),
            !sessions.isEmpty
        else {
            return
        }

        isProcessing = true
        defer { isProcessing = false }

        let totals = calculateTotals(from: sessions)
        guard totals.keystrokes > 0 else {
            AppLogger.shared.debug(
                "KeyboardSessionMonitor: No keystrokes to process"
            )
            return
        }

        guard let player = fetchPlayer() else {
            AppLogger.shared.error(
                "KeyboardSessionMonitor: Failed to fetch Player"
            )
            return
        }

        AppLogger.shared.debug(
            "KeyboardSessionMonitor: Processing \(sessions.count) sessions - \(totals.keystrokes) keystrokes → \(totals.keycaps) keycaps"
        )

        updatePlayer(player, with: totals)
        markSessionsAsProcessed(sessions)
        try? modelContext.save()

        AppLogger.shared.debug(
            "KeyboardSessionMonitor: Successfully processed sessions. Player now has \(player.currentKeycaps) keycaps"
        )

        // Clean up old sessions after successful processing
        await cleanupOldSessions()
    }

    /// Fetch completed sessions that haven't been processed yet
    @MainActor
    private func fetchCompletedUnprocessedSessions() -> [KeyboardSession]? {
        let descriptor = FetchDescriptor<KeyboardSession>(
            predicate: #Predicate {
                $0.processedAt == nil && $0.endDate != nil
            },
            sortBy: [SortDescriptor(\.createdAt, order: .forward)]
        )
        return try? modelContext.fetch(descriptor)
    }

    private func calculateTotals(from sessions: [KeyboardSession]) -> (
        keystrokes: Int, keycaps: Int
    ) {
        var totalKeystrokes = 0
        var totalKeycaps = 0

        for session in sessions {
            let sessionKeycaps = calculateKeycaps(for: session)
            totalKeystrokes += session.keystrokeCount
            totalKeycaps += sessionKeycaps
        }

        return (totalKeystrokes, totalKeycaps)
    }

    private func calculateKeycaps(for session: KeyboardSession) -> Int {
        // MVP: Bongo Player - 1 keystroke = 1 keycap
        // No special mechanics, straight conversion

        // Future job implementations will go here:
        // - Chatter: First 15 keystrokes * 2, remaining * reduced rate
        // - Writer: Multiplier builds from 0.8x to 1.2x over 80 keystrokes
        // - Coder: Bonuses for brackets, symbols, coding patterns

        return session.keystrokeCount
    }

    @MainActor
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

        // Track first activity date
        if player.firstActiveDate == nil {
            player.firstActiveDate = Date()
        }

        // Always update last activity
        player.lastActiveDate = Date()

        AppLogger.shared.debug(
            "KeyboardSessionMonitor: Updated player - Total keystrokes: \(player.totalKeystrokes), Current keycaps: \(player.currentKeycaps)"
        )
    }

    private func markSessionsAsProcessed(_ sessions: [KeyboardSession]) {
        let now = Date()
        for session in sessions {
            session.processedAt = now
        }
    }

    /// Clean up processed sessions older than 7 days
    /// Keeps them longer for analytics/debugging purposes
    @MainActor
    private func cleanupOldSessions() async {
        let sevenDaysAgo =
            Calendar.current.date(
                byAdding: .day,
                value: -7,
                to: Date()
            ) ?? Date()

        let descriptor = FetchDescriptor<KeyboardSession>(
            predicate: #Predicate {
                $0.processedAt != nil && $0.processedAt! < sevenDaysAgo
            }
        )
        guard let oldSessions = try? modelContext.fetch(descriptor),
            !oldSessions.isEmpty
        else {
            return
        }

        AppLogger.shared.debug(
            "KeyboardSessionMonitor: Cleaning up \(oldSessions.count) old sessions"
        )

        for session in oldSessions {
            modelContext.delete(session)
        }

        try? modelContext.save()
    }
}
