//
//  RequestError.swift
//  POPAPIKit
//
//  Created by Hanguang on 2017/8/2.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

import Foundation

/// `RequestError` represents a common error that occurs while building `URLRequest` from `Request`.
public enum RequestError: Error {
    /// Indicates `baseURL` of a type that conforms `Request` is invalid.
    case invalidBaseURL(URL)
    
    /// Indicates `URLRequest` built by `Request.buildURLRequest` is unexpected.
    case unexpectedURLRequest(URLRequest)
}

