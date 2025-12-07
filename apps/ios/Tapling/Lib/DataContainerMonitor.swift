//
//  DataContainerMonitor.swift
//  Tapling
//
//  Created by Benno on 07.12.25.
//

import CoreData
import Foundation
import SwiftData

@MainActor
final class DataContainerMonitor {
    private var observer: NSObjectProtocol?
    private var handlers: [String: () async -> Void] = [:]

    init() {
        startMonitoring()
    }

    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    /// Registers a handler to be called when a specific model type is saved
    func registerHandler(
        for modelName: String,
        handler: @escaping () async -> Void
    ) {
        handlers[modelName] = handler
    }

    private func startMonitoring() {
        observer = NotificationCenter.default.addObserver(
            forName: .NSManagedObjectContextDidSave,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }

            let changedModelNames = Self.extractChangedModelNames(
                from: notification
            )

            Task { @MainActor [weak self] in
                guard let self = self else { return }

                for modelName in changedModelNames {
                    if let handler = self.handlers[modelName] {
                        await handler()
                    }
                }
            }
        }
    }

    private static nonisolated func extractChangedModelNames(
        from notification: Notification
    ) -> Set<String> {
        guard let userInfo = notification.userInfo else {
            return []
        }

        let inserted =
            userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> ?? []
        let updated =
            userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> ?? []
        let deleted =
            userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> ?? []

        let allChanged = inserted.union(updated).union(deleted)

        return Set(allChanged.compactMap { $0.entity.name })
    }
}
