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

    static var bundleIdentifier: String {
        Bundle.main.bundleIdentifier ?? "com.buildergroup.Tapling"
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
        URL(
            string:
                "https://apps.apple.com/us/app/tapling-type-with-bongo-cat/id6756097345"
        )
    }

    static var privacyPolicyURL: URL? {
        URL(string: "https://builder.group/apps/tapling/legal/privacy")
    }

    static var githubURL: URL? {
        URL(string: "https://github.com/builder-group/tapling")
    }

    // MARK: - Feedback & Support

    static var feedbackEmail: String {
        "support@builder.group"
    }

    static func mailtoURL(subject: String) -> URL? {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = feedbackEmail
        components.queryItems = [
            URLQueryItem(name: "subject", value: "[Tapling] \(subject)")
        ]
        return components.url
    }
}
