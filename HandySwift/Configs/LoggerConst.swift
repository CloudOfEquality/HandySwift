//
//  LoggerConst.swift
//  WetestCloudgame
//
//  Created by xiutongmu on 2024/7/18.
//

import CocoaLumberjack
import Foundation

enum LoggerConst {

    static let logPrefix = "**UDT**"

    // Log level
    #if DEBUG
        static let logLevel: DDLogLevel = .debug
        static let showLogButton = true
    #else
        static let logLevel: DDLogLevel = .info
        static let showLogButton = false
    #endif

    // UDP Forward Format
    #if DEBUG
        static let udpLogForwardFormat = "plain|cloudtesting|%@|ioscloudgamedebug|%@|%@|%@\n"
    #else
        static let udpLogForwardFormat = "plain|cloudtesting|%@|ioscloudgame|%@|%@|%@\n"
    #endif
}
