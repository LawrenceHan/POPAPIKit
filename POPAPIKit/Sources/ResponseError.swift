//
//  ResponseError.swift
//  POPAPIKit
//
//  Created by Hanguang on 2017/8/2.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

import Foundation

/// `ResponseError` represents a common error that occurs while getting `Request.Response`
/// from raw result tuple `(Data?, URLResponse?, Error?)`.
public enum ResponseError: Error {
    /// Indicates the session client returned `URLResponse` that fails to down-cast to `HTTPURLResponse`.
    case nonHTTPURLResponse(URLResponse?)
    
    /// Indicates `HTTPURLResponse.statusCode` is not acceptable.
    /// In most cases, *acceptable* means the value is in `200..<300`.
    case unacceptableStatusCode(Int)
    
    /// Indicates `Any` that represents the response is unexpected.
    case unexpectedObject(Any)
}

