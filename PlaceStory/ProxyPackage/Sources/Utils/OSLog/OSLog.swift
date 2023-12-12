//
//  File.swift
//  
//
//  Created by 최제환 on 12/7/23.
//

import Foundation
import OSLog

extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier!
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let debug = OSLog(subsystem: subsystem, category: "Debug")
    static let info = OSLog(subsystem: subsystem, category: "Info")
    static let error = OSLog(subsystem: subsystem, category: "Error")
}

public struct Log {
    enum Level {
        /// 디버깅 로그
        case debug
        /// 문제 해결 정보
        case info
        /// 네트워크 로그
        case network
        /// 오류 로그
        case error
        case custom(category: String)
        
        fileprivate var category: String {
            switch self {
            case .debug:
                return "🟡 DEBUG"
            case .info:
                return "🟠 INFO"
            case .network:
                return "🔵 NETWORK"
            case .error:
                return "🔴 ERROR"
            case .custom(let category):
                return "🟢 \(category)"
            }
        }
        
        fileprivate var osLog: OSLog {
            switch self {
            case .debug:
                return OSLog.debug
            case .info:
                return OSLog.info
            case .network:
                return OSLog.network
            case .error:
                return OSLog.error
            case .custom:
                return OSLog.debug
            }
        }
        
        fileprivate var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .network:
                return .default
            case .error:
                return .error
            case .custom:
                return .debug
            }
        }
    }
    
    static private func log(_ message: Any, _ arguments: [Any], level: Level) {
        let extraMessage: String = arguments.map({ String(describing: $0) }).joined(separator: " ")
        let logger = Logger(subsystem: OSLog.subsystem, category: level.category)
        let logMessage = "\(message) \(extraMessage)"
        switch level {
        case .debug,
             .custom:
            logger.debug("\(logMessage, privacy: .public)")
        case .info:
            logger.info("\(logMessage, privacy: .public)")
        case .network:
            logger.log("\(logMessage, privacy: .public)")
        case .error:
            logger.error("\(logMessage, privacy: .public)")
        }
    }
}

// MARK: - utils
extension Log {
    public static func debug(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .debug)
    }
    
    public static func info(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .info)
    }
    
    public static func network(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .network)
    }
    
    public static func error(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .error)
    }
    
    public static func custom(category: String, _ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .custom(category: category))
    }
}
