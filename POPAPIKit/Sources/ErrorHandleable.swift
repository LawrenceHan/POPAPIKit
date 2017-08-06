//
//  ErrorHandleable.swift
//  POPAPIKit
//
//  Created by Hanguang on 2017/8/4.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

import Foundation

public protocol ErrorHandleable {
    /// Handle any error thrown during a network request process
    /// Default extension does nothing
    /// - Parameter error: SessionTaskError
    func handle(error: SessionTaskError)
}

public extension ErrorHandleable {
    func handle(error: SessionTaskError) {}
}
