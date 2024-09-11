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
    Storage.set(uint: level.rawValue, forKey: StorageConst.Value.globalUserLogLevel)
}

func getGlobalLogLevel() -> DDLogLevel {
    dynamicLogLevel
}

func getDefaultGlobalLogLevel() -> DDLogLevel {
    let level = Storage.uint(forKey: StorageConst.Value.globalUserLogLevel)
    return DDLogLevel(rawValue: level) ?? LoggerConst.logLevel
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

// MARK: - UDPLogForwarder

class UDPLogForwarder: DDAbstractLogger {
    private let client: UDPSocketClient

    init(client _client: UDPSocketClient) {
        client = _client
        super.init()
    }

    func generateTimeStampString(_ logMessage: DDLogMessage) -> String {
        MyLogFormatter.standardDateFormatter().string(from: logMessage.timestamp)
    }

    func generateLogLevelString(_ logMessage: DDLogMessage) -> String {
        switch logMessage.flag {
        case .error: "error"
        case .warning: "warning"
        case .info: "info"
        case .debug: "debug"
        case .verbose: "verbose"
        default: "unknown"
        }
    }

    func generateForwardContentDict(_ content: Any) -> [String: Any] {
        let deviceID = FCUUID.uuidForDevice() ?? ""
        let sessionID = FCUUID.uuidForSession() ?? ""

        return [
            "platform": "iOS",
            "version": IdentifierConst.LocalInfos.appLocalVersion ?? "0.0.0",
            "device": DataModel.shared.deviceModel,
            "username": DataModel.shared.username,
            "text": content,
            "dlogsreport": 1,
            "deviceID": deviceID,
            "sessionID": sessionID,
        ]
    }

    func serializeForwardContentDict(_ contentDict: [String: Any]) -> String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: contentDict, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            jsonString
        } else {
            "Error serializing JSON"
        }
    }

    override func log(message d: DDLogMessage) {
        guard let ivar = class_getInstanceVariable(object_getClass(self), "_logFormatter") else {
            return
        }
        if let ivarFormatter = object_getIvar(self, ivar) as? DDLogFormatter,
           /*
               * MUST use ivar to visit internal property for swift not providing a "_${prop}" way to avoid calling .self
               * Using "self." syntax to go through DDLog async queue will cause immediate deadlock
               */
           let formatted = ivarFormatter.format(message: d) {

            let timeStamp = generateTimeStampString(d)
            let level = generateLogLevelString(d)

            client.sendString(String(format: LoggerConst.udpLogForwardFormat,
                                     DeviceUtil.localIPAddress(),
                                     timeStamp,
                                     level,
                                     serializeForwardContentDict(generateForwardContentDict(formatted))),

                              toHost: RemoteConst.LogForwardAddress.ipAddress,
                              onPort: UInt16(RemoteConst.LogForwardAddress.port))
        }
    }
}
