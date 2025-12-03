//
//  SingletonModel.swift
//  Tapling
//
//  Created by Benno on 03.12.25.
//

import Foundation
import SwiftData

/// Protocol for singleton SwiftData models that have a default instance.
protocol SingletonModel: PersistentModel {
    /// The default instance of this model, used when creating new instances.
    static var `default`: Self { get }
    
    /// Fetches or creates the singleton instance in the given model context.
    /// Uses `default` to create a new instance if none exists.
    static func instance(with modelContext: ModelContext) -> Self
}

extension SingletonModel {
    /// Default implementation that fetches existing instance or creates one from `default`.
    static func instance(with modelContext: ModelContext) -> Self {
        let descriptor = FetchDescriptor<Self>()
        if let result = try? modelContext.fetch(descriptor).first {
            return result
        } else {
            let instance = Self.default
            modelContext.insert(instance)
            try? modelContext.save()
            return instance
        }
    }
}

