//
//  AppLogger.swift
//  Tapling
//
//  Created by Benno on 06.12.25.
//

import Foundation
import OSLog

final class AppLogger {
    static let shared = AppLogger()

    private let logger: Logger
    private let subsystem: String
    private let category: String
    private let appName: String

    init() {
        let appName = AppConfig.appName
        self.subsystem = AppConfig.bundleIdentifier
        self.category = appName
        self.appName = appName
        self.logger = Logger(subsystem: subsystem, category: category)
    }

    /// Logs a debug message (only visible in debug builds).
    func debug(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
            let fileName = (file as NSString).lastPathComponent
            logger.debug("[\(self.appName)] \(message) [\(fileName):\(line)]")
        #endif
    }

    /// Logs an info message.
    func info(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let fileName = (file as NSString).lastPathComponent
        logger.info("[\(self.appName)] \(message) [\(fileName):\(line)]")
    }

    /// Logs a warning message.
    func warning(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let fileName = (file as NSString).lastPathComponent
        logger.warning("[\(self.appName)] \(message) [\(fileName):\(line)]")
    }

    /// Logs an error message.
    func error(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let fileName = (file as NSString).lastPathComponent
        logger.error("[\(self.appName)] \(message) [\(fileName):\(line)]")
    }
}
