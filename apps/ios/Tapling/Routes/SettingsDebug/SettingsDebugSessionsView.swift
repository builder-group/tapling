//
//  SettingsDebugSessionsView.swift
//  Tapling
//
//  Created by Benno on 07.12.25.
//

import SwiftData
import SwiftUI

struct SettingsDebugSessionsView: View {
    @Query(sort: \KeyboardSession.createdAt, order: .reverse) private
        var sessions: [KeyboardSession]

    // MARK: - UI

    var body: some View {
        List {
            if sessions.isEmpty {
                ContentUnavailableView(
                    "No Sessions",
                    systemImage: "keyboard",
                    description: Text("No keyboard sessions found")
                )
            } else {
                Section {
                    Text("Total Sessions: \(sessions.count)")
                        .font(.headline)
                }

                Section("Sessions") {
                    ForEach(sessions) { session in
                        SessionRowView(session: session)
                    }
                }
            }
        }
        .navigationTitle("Sessions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct SessionRowView: View {
    let session: KeyboardSession

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Keystrokes: \(session.keystrokeCount)")
                    .font(.headline)
                Spacer()
                if session.processedAt != nil {
                    Label("Processed", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                } else {
                    Label("Pending", systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }

            Text("Start: \(session.startDate, style: .time)")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("End: \(session.endDate!, style: .time)")
                .font(.caption)
                .foregroundStyle(.secondary)

            if let processedAt = session.processedAt {
                Text("Processed: \(processedAt, style: .time)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        SettingsDebugSessionsView()
            .previewDataContainer()
    }
}
