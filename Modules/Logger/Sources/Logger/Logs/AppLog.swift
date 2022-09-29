//
//  AppLog.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Foundation

/// Application logger
/// Before use — set desired mode via `setMode` method
public protocol AppLog {
    static var shared: AppLog { get }
    
    /// Setup log destinations depends on passed mode
    /// - release: no logs collected
    /// - dev: OSLogDestination
    /// - qa: OSLogDestination + FileDestination
    func setMode(_ mode: AppLogMode)
    
    /// Send event to log system
    /// Available events:
    /// - BasicAppLogEvent
    /// - StorageLogEvent
    func log(_ event: AppLogEvent)
    
    func logDidCreateTask(_ task: URLSessionTask)
    
    func logUrlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    )
    
    func logUrlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didFinishCollecting metrics: URLSessionTaskMetrics
    )
    
    func logUrlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    )
}

final class AppLogImpl {
    private var destinations: [LogDestination]
    private var networkLogger: PulseNetworkEventLogger?

    static let shared: AppLog = AppLogImpl()
    
    //MARK: - Lifecycle
    private init() {
        destinations = []
    }
    
    func setMode(_ mode: AppLogMode) {
        switch mode {
        case .release:
            destinations.removeAll()
        case .dev:
            let osLog = OSLogDestination()
            let pulse = PulseLogDestination()
            destinations.append(osLog)
            destinations.append(pulse)
        case .qa:
            networkLogger = .init()
            let pulse = PulseLogDestination()
            destinations.append(pulse)
        }
    }
    
    private func getOSLogDestination() -> OSLogDestination? {
        guard let object = destinations.first(where: { $0 is OSLogDestination }),
                let destination = object as? OSLogDestination else {
            return nil
        }
        return destination
    }
}

//MARK: - AppLog
extension AppLogImpl: AppLog {
    func logDidCreateTask(_ task: URLSessionTask) {
        if let osLog = getOSLogDestination() {
            let event = CreateNetworkTaskEvent(task: task, level: .info)
            osLog.write(event)
        } else {
            networkLogger?.didCreateTask(task)
        }
    }
    
    func logUrlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let osLog = getOSLogDestination() {
            let event = DidReceiveDataNetworkEvent(
                task: dataTask,
                data: data,
                level: .info
            )
            osLog.write(event)
        } else {
            networkLogger?.urlSession(session, dataTask: dataTask, didReceive: data)
        }
    }
    
    func logUrlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        networkLogger?.urlSession(session, task: task, didFinishCollecting: metrics)
    }
    
    func logUrlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let osLog = getOSLogDestination() {
            let event = DidCompleteWithErrorNetworkEvent(
                task: task,
                error: error,
                level: .error
            )
            osLog.write(event)
        } else {
            networkLogger?.urlSession(session, task: task, didCompleteWithError: error)
        }
    }
    
    func log(_ event: AppLogEvent) {
        guard !destinations.isEmpty else { return }
        destinations.forEach({
            $0.write(event)
        })
    }
}
