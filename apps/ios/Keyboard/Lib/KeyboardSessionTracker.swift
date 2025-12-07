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

    private var sessionKeystrokes: Int = 0
    private var sessionStartDate: Date?

    /// Check if tracking is enabled and Full Access is granted
    @MainActor
    private func canTrack() -> Bool {
        let modelContext = KeyboardDataContainer.shared.modelContext
        let settings = modelContext.fetchKeyboardTaplingSettings()
        return settings.trackSessions && KeyboardStatusContext.hasFullAccess()
    }

    /// Start a new session (call when keyboard appears)
    @MainActor
    func startSession() {
        guard canTrack() else { return }
        sessionStartDate = Date()
        sessionKeystrokes = 0
    }

    /// Track a keystroke (in-memory only, no I/O)
    @MainActor
    func trackKeystroke() {
        guard canTrack() else { return }
        if sessionStartDate == nil {
            startSession()
        }
        sessionKeystrokes += 1
    }

    /// Save current session to SwiftData (call when keyboard closes)
    @MainActor
    func saveSession() {
        guard canTrack() else {
            sessionKeystrokes = 0
            sessionStartDate = nil
            return
        }

        guard sessionKeystrokes > 0 else {
            sessionStartDate = nil
            return
        }

        guard let startDate = sessionStartDate else {
            return
        }

        let endDate = Date()

        do {
            let modelContext = KeyboardDataContainer.shared.modelContext
            let session = KeyboardSession(
                startDate: startDate,
                endDate: endDate,
                keystrokeCount: sessionKeystrokes
            )
            modelContext.insert(session)
            try modelContext.save()

            sessionKeystrokes = 0
            sessionStartDate = nil
        } catch {
            sessionKeystrokes = 0
            sessionStartDate = nil
        }
    }
}
