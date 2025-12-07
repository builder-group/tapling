//
//  KeyboardSession.swift
//  Tapling
//
//  Created by Benno on 07.12.25.
//

import Foundation
import SwiftData

@Model
final class KeyboardSession {
    var id: UUID
    var startDate: Date
    var endDate: Date
    var keystrokeCount: Int
    var createdAt: Date
    var processedAt: Date?

    init(
        id: UUID = UUID(),
        startDate: Date,
        endDate: Date,
        keystrokeCount: Int,
        createdAt: Date = Date(),
        processedAt: Date? = nil
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.keystrokeCount = keystrokeCount
        self.createdAt = createdAt
        self.processedAt = processedAt
    }
}
