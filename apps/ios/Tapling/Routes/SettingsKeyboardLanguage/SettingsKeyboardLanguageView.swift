//
//  SettingsKeyboardLanguageView.swift
//  Tapling
//
//  Created by Benno on 05.12.25.
//

import KeyboardKit
import SwiftData
import SwiftUI

struct SettingsKeyboardLanguageView: View {
    @QuerySingleton private var keyboardSettings: KeyboardSettings
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Form {
            Section {
                ForEach(KeyboardLanguage.allCases) { language in
                    Button {
                        keyboardSettings.language = language
                        try? modelContext.save()
                    } label: {
                        HStack {
                            Text(language.displayNameWithResolved)
                                .foregroundStyle(.primary)

                            Spacer()

                            if keyboardSettings.language == language {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Language")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsKeyboardLanguageView()
            .previewDataContainer()
    }
}
