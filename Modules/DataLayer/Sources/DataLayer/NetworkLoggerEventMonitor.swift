//
//  NetworkLoggerEventMonitor.swift
//

import Foundation
import Alamofire

/// Event monitor for handle network event and log them to log system
/// - [https://kean.blog/pulse/guides/networking](See Pulse/Alamofire) docs for detailed integration
/// - [https://github.com/kean/Pulse/tree/master/Integrations/IntegrationsExamples](Integrations Examples)
public final class NetworkLoggerEventMonitor: EventMonitor {
    private let onCreateTask: (URLSessionTask) -> Void
    private let onDidReceiveData: (Data, URLSessionDataTask) -> Void
    private let onDidFinishCollectingMetrics: (URLSessionTaskMetrics, URLSessionTask) -> Void
    private let onDidCompleteWithError: (URLSessionTask, Error?) -> Void
    
    public init(
        onCreateTask: @escaping (URLSessionTask) -> Void,
        onDidReceiveData: @escaping (Data, URLSessionDataTask) -> Void,
        onDidFinishCollectingMetrics: @escaping (URLSessionTaskMetrics, URLSessionTask) -> Void,
        onDidCompleteWithError: @escaping (URLSessionTask, Error?) -> Void
    ) {
        self.onCreateTask = onCreateTask
        self.onDidReceiveData = onDidReceiveData
        self.onDidFinishCollectingMetrics = onDidFinishCollectingMetrics
        self.onDidCompleteWithError = onDidCompleteWithError
    }
    
    public func request(_ request: Request, didCreateTask task: URLSessionTask) {
        onCreateTask(task)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        onDidReceiveData(data, dataTask)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        onDidFinishCollectingMetrics(metrics, task)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        onDidCompleteWithError(task, error)
    }
}
