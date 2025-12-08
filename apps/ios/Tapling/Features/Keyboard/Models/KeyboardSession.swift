//
//  KeyboardSession.swift
//  Tapling
//
//  Created by Benno on 07.12.25.
//

import Foundation
import SwiftData

/// Represents one keyboard opening from appear to dismiss.
/// Created when keyboard opens, updated periodically (auto-save every 50 keystrokes),
/// and finalized when keyboard closes. Main app processes sessions to award keycaps.
@Model
final class KeyboardSession {
    var id: UUID

    /// When the keyboard opened
    var startDate: Date
    /// When the keyboard closed (nil = session still in progress)
    var endDate: Date?
    /// Total keystrokes during this session
    var keystrokeCount: Int
    /// When this record was created
    var createdAt: Date
    /// When this session was last updated (for checkpoint tracking)
    var lastUpdatedAt: Date
    /// When the main app processed this session and awarded keycaps (nil = not yet processed)
    var processedAt: Date?

    init(
        id: UUID = UUID(),
        startDate: Date,
        endDate: Date? = nil,
        keystrokeCount: Int,
        createdAt: Date = Date(),
        lastUpdatedAt: Date = Date(),
        processedAt: Date? = nil,
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.keystrokeCount = keystrokeCount
        self.createdAt = createdAt
        self.lastUpdatedAt = lastUpdatedAt
        self.processedAt = processedAt
    }
}
