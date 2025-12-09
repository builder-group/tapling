//
//  KeyboardSessionTracker.swift
//  Keyboard
//
//  Created by Benno on 07.12.25.
//

import Foundation
import KeyboardKit
import SwiftData

final class KeyboardSessionTracker {
    static let shared = KeyboardSessionTracker()

    @MainActor
    private var modelContext: ModelContext {
        KeyboardDataContainer.shared.modelContext
    }

    private var currentSessionID: UUID?
    private var sessionKeystrokes: Int = 0
    private var isTrackingEnabled: Bool = false
    private var lastSaveKeystrokeCount: Int = 0

    private init() {}

    /// Start a new session (call when keyboard appears)
    @MainActor
    func startSession() {
        // Refresh settings (user might have toggled tracking in main app)
        let settings = modelContext.fetchKeyboardSettings()
        isTrackingEnabled =
            settings.trackSessions && KeyboardStatusContext.hasFullAccess()

        guard isTrackingEnabled else {
            reset()
            return
        }

        // Clean up any existing session state
        reset()

        do {
            // Create new session
            let session = KeyboardSession(
                startDate: Date(),
                endDate: nil,  // endDate = nil (session in progress)
                keystrokeCount: 0
            )
            modelContext.insert(session)
            try modelContext.save()

            currentSessionID = session.id

            AppLogger.shared.debug(
                "KeyboardSessionTracker: Started session: \(session.id)"
            )
        } catch {
            AppLogger.shared.error(
                "KeyboardSessionTracker: Failed to start session: \(error)"
            )
            reset()
        }
    }

    /// Track a keystroke (in-memory only, no I/O)
    func trackKeystroke() {
        guard isTrackingEnabled, currentSessionID != nil else { return }

        sessionKeystrokes += 1

        // Auto-save every 50 keystrokes to prevent data loss on crashes
        if sessionKeystrokes - lastSaveKeystrokeCount >= 50 {
            Task { @MainActor in
                updateSessionProgress()
            }
        }
    }

    /// End and finalize the current session (call when keyboard closes)
    @MainActor
    func endSession() {
        guard isTrackingEnabled else {
            reset()
            return
        }

        guard let sessionID = currentSessionID else {
            reset()
            return
        }

        do {
            // Fetch the existing session
            let descriptor = FetchDescriptor<KeyboardSession>(
                predicate: #Predicate { $0.id == sessionID }
            )
            guard let session = try modelContext.fetch(descriptor).first else {
                AppLogger.shared.error(
                    "KeyboardSessionTracker: Session not found: \(sessionID)"
                )
                reset()
                return
            }

            // Finalize the session
            session.endDate = Date()
            session.keystrokeCount = sessionKeystrokes
            session.lastUpdatedAt = Date()

            try modelContext.save()

            AppLogger.shared.debug(
                "KeyboardSessionTracker: Ended session: \(sessionKeystrokes) keystrokes"
            )
        } catch {
            AppLogger.shared.error(
                "KeyboardSessionTracker: Failed to end session: \(error)"
            )
        }

        reset()
    }

    /// Update session progress (checkpoint without closing session)
    @MainActor
    private func updateSessionProgress() {
        guard let sessionID = currentSessionID else { return }
        guard sessionKeystrokes > lastSaveKeystrokeCount else { return }

        do {
            let descriptor = FetchDescriptor<KeyboardSession>(
                predicate: #Predicate { $0.id == sessionID }
            )
            guard let session = try modelContext.fetch(descriptor).first else {
                AppLogger.shared.error(
                    "KeyboardSessionTracker: Session not found for update: \(sessionID)"
                )
                return
            }

            // Update keystroke count (session still in progress, endDate remains nil)
            session.keystrokeCount = sessionKeystrokes
            session.lastUpdatedAt = Date()

            try modelContext.save()

            lastSaveKeystrokeCount = sessionKeystrokes

            AppLogger.shared.debug(
                "KeyboardSessionTracker: Updated session: \(sessionKeystrokes) keystrokes"
            )
        } catch {
            AppLogger.shared.error(
                "KeyboardSessionTracker: Failed to update session: \(error)"
            )
        }
    }

    private func reset() {
        sessionKeystrokes = 0
        currentSessionID = nil
        lastSaveKeystrokeCount = 0
    }
}
