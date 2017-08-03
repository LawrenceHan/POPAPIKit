//
//  Session.swift
//  POPAPIKit
//
//  Created by Hanguang on 2017/8/1.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

import Foundation
import Result

private var taskRequestKey = 0

/// `Session` manages tasks for HTTP/HTTPS requests.
open class Session {
    /// The client that connects `Session` instance and lower level backend.
    public let client: SessionClient
    
    /// The default callback queue for `send(_:handler:)`.
    public let callbackQueue: DispatchQueue
    
    /// Returns `Session` instance that is initialized with `client`.
    /// - parameter client: The client that connects lower level backend with Session interface.
    /// - parameter callbackQueue: The default callback queue for `send(_:handler:)`.
    public init(client: SessionClient, callbackQueue: DispatchQueue = DispatchQueue.main) {
        self.client = client
        self.callbackQueue = callbackQueue
    }
    
    /// Returns a default `Session`. A global constant `APIKit` is a shortcut of `Session.default`.
    open static let `default` = Session()
    
    // Shared session for class methods
    private convenience init() {
        let configuration = URLSessionConfiguration.default
        let client = URLSessionClient(configuration: configuration)
        self.init(client: client)
    }
    
    /// Sends a request and receives the result as the argument of `handler` closure. This method takes
    /// a type parameter `Request` that conforms to `Request` protocol. The result of passed request is
    /// expressed as `Result<Request.Response, SessionTaskError>`. Since the response type
    /// `Request.Response` is inferred from `Request` type parameter, the it changes depending on the request type.
    /// - parameter request: The request to be sent.
    /// - parameter callbackQueue: The queue where the handler runs. If this parameters is `nil`, default `callbackQueue` of `Session` will be used.
    /// - parameter handler: The closure that receives result of the request.
    /// - returns: The new session task.
    @discardableResult
    open func send<Request: POPAPIKit.Request>(_ request: Request, callbackQueue: DispatchQueue? = nil, handler: @escaping (Result<Request.Response, SessionTaskError>) -> Void = { _ in }) -> SessionTask? {
        let callbackQueue = callbackQueue ?? self.callbackQueue
        
        let urlRequest: URLRequest
        do {
            urlRequest = try request.buildURLRequest()
        } catch {
            callbackQueue.async {
                handler(.failure(.requestError(error)))
            }
            return nil
        }
        
        let task = client.createTask(with: urlRequest) { data, urlResponse, error in
            let result: Result<Request.Response, SessionTaskError>
            
            switch (data, urlResponse, error) {
            case (_, _, let error?):
                result = .failure(.connectionError(error))
            case (let data?, let urlResponse as HTTPURLResponse, _):
                do {
                    result = .success(try request.parse(data: data as Data, urlResponse: urlResponse))
                } catch {
                    result = .failure(.responseError(error))
                }
            default:
                result = .failure(.responseError(ResponseError.nonHTTPURLResponse(urlResponse)))
            }
            
            callbackQueue.async {
                handler(result)
            }
        }
        
        setRequest(request, forTask: task)
        task.resume()
        
        return task
    }
    
    /// Cancels requests that passes the test.
    /// - parameter requestType: The request type to cancel.
    /// - parameter test: The test closure that determines if a request should be cancelled or not.
    open func cancelRequests<Request: POPAPIKit.Request>(with requestType: Request.Type, passingTest test: @escaping (Request) -> Bool = { _ in true }) {
        client.getTasks { [weak self] tasks in
            return tasks
                .filter { task in
                    if let request = self?.requestForTask(task) as Request? {
                        return test(request)
                    } else {
                        return false
                    }
                }
                .forEach { $0.cancel() }
        }
    }
    
    private func setRequest<Request: POPAPIKit.Request>(_ request: Request, forTask task: SessionTask) {
        objc_setAssociatedObject(task, &taskRequestKey, request, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func requestForTask<Request: POPAPIKit.Request>(_ task: SessionTask) -> Request? {
        return objc_getAssociatedObject(task, &taskRequestKey) as? Request
    }
}

// MARK: - Default POPAPIKit

public let APIKit = Session.default
