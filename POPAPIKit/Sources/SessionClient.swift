//
//  SessionClient.swift
//  POPAPIKit
//
//  Created by Hanguang on 2017/8/2.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

import Foundation

/// `SessionTask` protocol represents a task for a request.
public protocol SessionTask: class {
    func resume()
    func cancel()
}

/// `SessionClient` protocol provides interface to connect lower level networking backend with `Session`.
/// APIKit provides `URLSessionClient`, which conforms to `SessionClient`, to connect `URLSession`
/// with `Session`.
public protocol SessionClient {
    /// Returns instance that conforms to `SessionTask`. `handler` must be called after success or failure.
    func createTask(with URLRequest: URLRequest, handler: @escaping (Data?, URLResponse?, Error?) -> Void) -> SessionTask
    
    /// Collects tasks from backend networking stack. `handler` must be called after collecting.
    func getTasks(with handler: @escaping ([SessionTask]) -> Void)
}
