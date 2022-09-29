//
//  AppLog.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Foundation

/// Enumeration of an available application log system modes. Should define the current mode in xcconfig for a project scheme
public enum AppLogMode {
    /// Log all events to Console.app, Xcode console and file
    case dev
    /// Log all events to Console.app and file
    case qa
    /// Don't log any events
    case release
}

/// Enumeration of an available application log events level
public enum AppLogEventLevel:
    String,
    Codable
{
    case debug
    case error
    case info
    
    var marker: String {
        switch self {
        case .error:
            return "🔴ERROR"
        case .debug:
            return "🔵DEBUG"
        case .info:
            return "⚪️INFO"
        }
    }
}

/// Enumerations of an available log type
public enum AppLogRecordType:
    String,
    Codable
{
    case basic
    case storage
    case network
}


/// Base type for application log. Can use for your own custom events
public protocol AppLogEvent: Encodable {
    /// Content of details about event
    var content: String { get }
    /// Log level for event
    var level: AppLogEventLevel { get }
    /// Type of an log event
    var type: AppLogRecordType { get }
    /// Log event creation date
    var creationDate: Date { get }
    /// Number of line where event was created
    var line: Int { get }
    /// Function name where event was created
    var function: String { get }
    /// File name where event was created
    var file: String { get }
    
    func makeData(with encoder: JSONEncoder) -> Data?
}

public extension AppLogEvent {
    func makeData(with encoder: JSONEncoder) -> Data? {
        do {
            return try encoder.encode(self)
        } catch {
            return nil
        }
    }
}

/// Basic log event. Suitable for most cases
public struct BasicAppLogEvent:
    AppLogEvent,
    Encodable
{
    public let content: String
    public let level: AppLogEventLevel
    public let type: AppLogRecordType
    public let creationDate: Date
    public let line: Int
    public let function: String
    public let file: String

    public init(
        content: String,
        level: AppLogEventLevel,
        line: Int = #line,
        function: String = #function,
        file: String = #file
    ) {
        self.content = content
        self.level = level
        self.type = .basic
        self.creationDate = .init()
        self.line = line
        self.function = function
        self.file = file
    }
}

/// Base event for an application storage
public struct StorageLogEvent:
    AppLogEvent,
    Encodable
{
    public let content: String
    public let level: AppLogEventLevel
    public let type: AppLogRecordType
    public let creationDate: Date
    public let line: Int
    public let function: String
    public let file: String
    
    public init(
        content: String,
        level: AppLogEventLevel,
        line: Int = #line,
        function: String = #function,
        file: String = #file
    ) {
        self.level = level
        self.function = function
        self.line = line
        self.creationDate = .init()
        self.type = .storage
        self.file = file
        self.content =
        """
        Storage
        \(content)
        """
    }
}

struct CreateNetworkTaskEvent:
    AppLogEvent,
    Encodable
{
    public let content: String
    public let level: AppLogEventLevel
    public let type: AppLogRecordType
    public let creationDate: Date
    public let line: Int
    public let function: String
    public let file: String
    
    public init(
        task: URLSessionTask,
        level: AppLogEventLevel,
        line: Int = #line,
        function: String = #function,
        file: String = #file
    ) {
        self.level = level
        self.function = function
        self.line = line
        self.creationDate = .init()
        self.type = .network
        self.file = file
        self.content =
        """
        CreateNetworkTaskEvent
        URL:\(task.currentRequest?.url?.absoluteString ?? "nil")
        """
    }
}

struct DidReceiveDataNetworkEvent:
    AppLogEvent,
    Encodable
{
    public let content: String
    public let level: AppLogEventLevel
    public let type: AppLogRecordType
    public let creationDate: Date
    public let line: Int
    public let function: String
    public let file: String
    
    public init(
        task: URLSessionTask,
        data: Data,
        level: AppLogEventLevel,
        line: Int = #line,
        function: String = #function,
        file: String = #file
    ) {
        self.level = level
        self.function = function
        self.line = line
        self.creationDate = .init()
        self.type = .network
        self.file = file
        
        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        
        self.content =
        """
        DidReceiveDataNetworkEvent
        URL:\(task.currentRequest?.url?.absoluteString ?? "nil")
        Response: \(json ?? [String : Any]())
        """
    }
}

struct DidCompleteWithErrorNetworkEvent:
    AppLogEvent,
    Encodable
{
    public let content: String
    public let level: AppLogEventLevel
    public let type: AppLogRecordType
    public let creationDate: Date
    public let line: Int
    public let function: String
    public let file: String
    
    public init(
        task: URLSessionTask,
        error: Error?,
        level: AppLogEventLevel,
        line: Int = #line,
        function: String = #function,
        file: String = #file
    ) {
        self.level = level
        self.function = function
        self.line = line
        self.creationDate = .init()
        self.type = .network
        self.file = file
        
        let errorText = error?.localizedDescription ?? "Empty error description"
        
        self.content =
        """
        DidCompleteWithErrorNetworkEvent
        URL:\(task.currentRequest?.url?.absoluteString ?? "nil")
        Error: \(errorText)
        """
    }
}


