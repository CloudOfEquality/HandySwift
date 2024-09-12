//
//  LoggerUtil.swift
//  WetestCloudgame
//
//  Created by xiutongmu on 2024/7/3.
//

import CocoaLumberjack
import Foundation
import UIKit

// MARK: - Log Wrappers

func printCallLocation(file: String = #file, line: Int = #line) {
    print("Function called from file: \(file), line: \(line)")
}

func logVerbose(_ message: String, _ args: CVarArg...,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line) {
    let formattedMessage = String(format: message, arguments: args)
    DDLogVerbose("\(LoggerConst.logPrefix): \(formattedMessage)", file: file, function: function, line: line)
}

func logDebug(_ message: String, _ args: CVarArg...,
              file: StaticString = #file,
              function: StaticString = #function,
              line: UInt = #line) {
    let formattedMessage = String(format: message, arguments: args)
    DDLogDebug("\(LoggerConst.logPrefix): \(formattedMessage)", file: file, function: function, line: line)
}

func logInfo(_ message: String, _ args: CVarArg...,
             file: StaticString = #file,
             function: StaticString = #function,
             line: UInt = #line) {
    let formattedMessage = String(format: message, arguments: args)
    DDLogInfo("\(LoggerConst.logPrefix): \(formattedMessage)", file: file, function: function, line: line)
}

func logWarn(_ message: String, _ args: CVarArg...,
             file: StaticString = #file,
             function: StaticString = #function,
             line: UInt = #line) {
    let formattedMessage = String(format: message, arguments: args)
    DDLogWarn("\(LoggerConst.logPrefix): \(formattedMessage)", file: file, function: function, line: line)
}

func logError(_ message: String, _ args: CVarArg...,
              file: StaticString = #file,
              function: StaticString = #function,
              line: UInt = #line) {
    let formattedMessage = String(format: message, arguments: args)
    DDLogError("\(LoggerConst.logPrefix): \(formattedMessage)", file: file, function: function, line: line)
}

// MARK: - DDLog Configs

func setGlobalLogLevel(_ level: DDLogLevel) {
    dynamicLogLevel = level
}

func getGlobalLogLevel() -> DDLogLevel {
    dynamicLogLevel
}

func restoreLogLevelToDefault() {
    setGlobalLogLevel(LoggerConst.logLevel)
}

// MARK: - MyLogFormatter

class MyLogFormatter: NSObject, DDLogFormatter {
    private let dateFormatter: DateFormatter

    override init() {
        dateFormatter = MyLogFormatter.standardDateFormatter()
        super.init()
    }

    class func standardDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        #if DEBUG
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        #else
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        #endif
        dateFormatter.timeZone = .current
        return dateFormatter
    }

    func generateLogLevelString(_ logMessage: DDLogMessage) -> String {
        switch logMessage.flag {
        case .error: "EROR"
        case .warning: "WARN"
        case .info: "INFO"
        case .debug: "DBUG"
        case .verbose: "VERB"
        default: "UNKNOWN"
        }
    }

    func format(message logMessage: DDLogMessage) -> String? {
        let logLevel = generateLogLevelString(logMessage)
        let formattedDate = dateFormatter.string(from: logMessage.timestamp)
        #if DEBUG
            var loc = if let function = logMessage.function {
                "\(logMessage.fileName):\(logMessage.line)-\(function)"
            } else {
                "\(logMessage.fileName):\(logMessage.line)"
            }
            return "\(formattedDate) [\(logLevel)] [\(loc)] \(logMessage.message)"
        #else
            return "\(formattedDate) [\(logLevel)] \(logMessage.message)"
        #endif
    }
}
