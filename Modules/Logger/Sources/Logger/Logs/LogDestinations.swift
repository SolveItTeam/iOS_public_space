//
//  AppLog.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import os.log
import Foundation
import Pulse
import Logging

/// Base type for log destination
protocol LogDestination {
    func write(_ event: AppLogEvent)
}

/// Log destination that writes events to an OSLog system. All events marked as public and available in Console.app for *application Bundle.main.bundleIdentifier* subsystem
final class OSLogDestination: LogDestination {
    private let log: OSLog
    
    init() {
        log = .init(subsystem: Bundle.main.bundleIdentifier ?? "", category: "DEV Logs")
    }
    
    func write(_ event: AppLogEvent) {
        var osLogLevel: OSLogType
        switch event.level {
        case .debug:
            osLogLevel = .debug
        case .error:
            osLogLevel = .error
        case .info:
            osLogLevel = .info
        }
        
        let fullLog =
        """
        [\(event.level.marker)]
        \(event.content)
        File: \(event.file)
        Function: \(event.function)
        Line: \(event.line)
        """
        
        os_log(
            "%{public}@",
            log: log,
            type: osLogLevel,
            fullLog
        )
    }
}

final class PulseLogDestination: LogDestination {
    private let pulse: PersistentLogHandler
    
    init() {
        pulse = .init(label: "DEV Logs")
    }
    
    func write(_ event: AppLogEvent) {
        var eventLevel: Logging.Logger.Level
        switch event.level {
        case .error:
            eventLevel = .error
        case .debug:
            eventLevel = .debug
        case .info:
            eventLevel = .info
        }
        
        pulse.log(
            level: eventLevel,
            message: Logger.Message.init(stringLiteral: event.content),
            metadata: nil,
            file: event.file,
            function: event.function,
            line: UInt(event.line)
        )
    }
}

class PulseNetworkEventLogger {
    private let logger: NetworkLogger
    
    init() {
        logger = .init()
    }
    
    func didCreateTask(_ task: URLSessionTask) {
        logger.logTaskCreated(task)
    }
    
    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {
        logger.logDataTask(dataTask, didReceive: data)
        guard let response = dataTask.response else { return }
        logger.logDataTask(dataTask, didReceive: response)
    }
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didFinishCollecting metrics: URLSessionTaskMetrics
    ) {
        logger.logTask(task, didFinishCollecting: metrics)
    }
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {
        logger.logTask(task, didCompleteWithError: error)
    }
}
