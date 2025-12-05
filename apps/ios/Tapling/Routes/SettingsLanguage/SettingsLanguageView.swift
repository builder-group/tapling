//
//  SettingsLanguageView.swift
//  Tapling
//
//  Created by Benno on 05.12.25.
//

import KeyboardKit
import SwiftData
import SwiftUI

struct SettingsLanguageView: View {
    @QuerySingleton private var keyboardSettings: KeyboardSettings
    @Environment(\.modelContext) private var modelContext

    private let availableLanguages: [(code: String, name: String)] = [
        ("system", "System Default"),
        ("en", "English"),
        ("de", "German"),
    ]

    private var languageBinding: Binding<String> {
        Binding(
            get: { keyboardSettings.languageCode },
            set: { newValue in
                keyboardSettings.languageCode = newValue
                try? modelContext.save()
            }
        )
    }

    var body: some View {
        Form {
            Section {
                ForEach(availableLanguages, id: \.code) { language in
                    Button {
                        languageBinding.wrappedValue = language.code
                    } label: {
                        HStack {
                            Text(language.name)
                                .foregroundStyle(.primary)

                            Spacer()

                            if languageBinding.wrappedValue == language.code {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
            } footer: {
                Text(
                    "Select the language layout for the keyboard. 'System Default' uses the active keyboard language."
                )
            }
        }
        .navigationTitle("Language")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsLanguageView()
            .previewDataContainer()
    }
}
