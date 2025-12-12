//
//  KeyboardStatusView.swift
//  Tapling
//
//  Created by Benno on 12.12.25.
//

import KeyboardKit
import SwiftUI

struct KeyboardStatusView: View {
    @Environment(\.scenePhase) private var scenePhase

    var showKeyboardEnabled: Bool = true
    var showFullAccess: Bool = true
    var style: Style = .standalone
    var onStatusChange: ((Bool, Bool) -> Void)? = nil

    @State private var isKeyboardEnabled = false
    @State private var isFullAccessEnabled = false

    private let keyboardStatus: KeyboardStatusContext

    init(
        bundleId: String = "com.buildergroup.Tapling.Keyboard",
        showKeyboardEnabled: Bool = true,
        showFullAccess: Bool = true,
        style: Style = .standalone,
        onStatusChange: ((Bool, Bool) -> Void)? = nil
    ) {
        self.showKeyboardEnabled = showKeyboardEnabled
        self.showFullAccess = showFullAccess
        self.style = style
        self.onStatusChange = onStatusChange
        self.keyboardStatus = KeyboardStatusContext(bundleId: bundleId)
    }

    enum Style {
        case form
        case standalone
    }

    // MARK: - UI

    var body: some View {
        Group {
            switch style {
            case .form:
                formView
            case .standalone:
                standaloneView
            }
        }
        .onAppear {
            checkStatus()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                checkStatus()
            }
        }
    }

    private var formView: some View {
        Group {
            if showKeyboardEnabled {
                StatusRowView(
                    title: "Keyboard Enabled",
                    isEnabled: isKeyboardEnabled,
                    action: openSystemSettings
                )
            }

            if showFullAccess {
                StatusRowView(
                    title: "Full Access Enabled",
                    isEnabled: isFullAccessEnabled,
                    action: openSystemSettings
                )
            }
        }
    }

    private var standaloneView: some View {
        VStack(spacing: 12) {
            if showKeyboardEnabled {
                statusButton(
                    title: "Keyboard Enabled",
                    isEnabled: isKeyboardEnabled
                )
            }

            if showFullAccess {
                statusButton(
                    title: "Full Access Enabled",
                    isEnabled: isFullAccessEnabled
                )
            }
        }
    }

    private func statusButton(title: String, isEnabled: Bool) -> some View {
        Button(action: openSystemSettings) {
            HStack(spacing: 12) {
                Image(
                    systemName: isEnabled
                        ? "checkmark.circle.fill"
                        : "exclamationmark.circle.fill"
                )
                .foregroundStyle(isEnabled ? .green : .yellow)
                .font(.title3)

                Text(title)
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.gray.opacity(0.1))
            )
        }
    }

    // MARK: - Actions

    private func checkStatus() {
        keyboardStatus.refresh()
        isKeyboardEnabled = keyboardStatus.isKeyboardEnabled
        isFullAccessEnabled =
            isKeyboardEnabled && keyboardStatus.isFullAccessEnabled
        onStatusChange?(isKeyboardEnabled, isFullAccessEnabled)
    }

    private func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url)
    }
}

private struct StatusRowView: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(
                    systemName: isEnabled
                        ? "checkmark.circle.fill"
                        : "exclamationmark.circle.fill"
                )
                .foregroundStyle(isEnabled ? .green : .yellow)
                .font(.title3)

                Text(title)
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview("Form Style") {
    NavigationStack {
        Form {
            Section("KEYBOARD") {
                KeyboardStatusView(style: .form)
            }
        }
    }
}

#Preview("Standalone Style - Both") {
    KeyboardStatusView(style: .standalone)
        .padding()
}

#Preview("Standalone Style - Keyboard Only") {
    KeyboardStatusView(
        showKeyboardEnabled: true,
        showFullAccess: false,
        style: .standalone
    )
    .padding()
}

#Preview("Standalone Style - Full Access Only") {
    KeyboardStatusView(
        showKeyboardEnabled: false,
        showFullAccess: true,
        style: .standalone
    )
    .padding()
}
