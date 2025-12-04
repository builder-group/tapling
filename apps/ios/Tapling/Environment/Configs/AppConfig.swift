//
//  AppConfig.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import Foundation

struct AppConfig {
    static let shared = AppConfig()

    private init() {}

    // MARK: - App Information

    var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName")
            as? String
            ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName")
            as? String
            ?? "Tapling"
    }

    var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
            as? String ?? "1.0.0"
    }

    var build: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
            ?? "1"
    }

    // MARK: - External Links

    var websiteURL: URL? {
        URL(string: "https://tapling.app")
    }

    var appStoreURL: URL? {
        // TODO: Replace with actual App Store URL once published
        URL(string: "https://apps.apple.com/app/tapling")
    }

    var privacyPolicyURL: URL? {
        URL(string: "https://tapling.app/legal/privacy")
    }

    // MARK: - Feedback & Support

    var feedbackEmail: String {
        "feedback@tapling.app"
    }

    func mailtoURL(subject: String) -> URL? {
        let encodedSubject =
            subject.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ) ?? subject
        return URL(string: "mailto:\(feedbackEmail)?subject=\(encodedSubject)")
    }
}
