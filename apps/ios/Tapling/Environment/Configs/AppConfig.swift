//
//  AppConfig.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import Foundation

enum AppConfig {
    // MARK: - App Information

    static var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName")
            as? String
            ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName")
            as? String
            ?? "Tapling"
    }

    static var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
            as? String ?? "1.0.0"
    }

    static var build: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
            ?? "1"
    }

    // MARK: - External Links

    static var websiteURL: URL? {
        URL(string: "https://tapling.app")
    }

    static var appStoreURL: URL? {
        // TODO: Replace with actual App Store URL once published
        URL(string: "https://apps.apple.com/app/tapling")
    }

    static var privacyPolicyURL: URL? {
        URL(string: "https://tapling.app/legal/privacy")
    }

    // MARK: - Feedback & Support

    static var feedbackEmail: String {
        "feedback@tapling.app"
    }

    static func mailtoURL(subject: String) -> URL? {
        let encodedSubject =
            subject.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ) ?? subject
        return URL(string: "mailto:\(feedbackEmail)?subject=\(encodedSubject)")
    }
}
