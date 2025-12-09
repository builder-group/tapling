//
//  AppSettings.swift
//  Tapling
//
//  Created by Benno on 07.12.25.
//

import Foundation
import SwiftData

@Model
final class AppSettings: SingletonModel {
    var debug: Bool

    init(debug: Bool = false) {
        self.debug = debug
    }

    static var `default`: AppSettings {
        AppSettings()
    }
}

