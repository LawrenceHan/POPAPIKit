//
//  SessionTaskError.swift
//  POPAPIKit
//
//  Created by Hanguang on 2017/8/2.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

import Foundation

/// `SessionTaskError` represents an error that occurs while task for a request.
public enum SessionTaskError: Error {
    /// Error of `URLSession`.
    case connectionError(Error)
    
    /// Error while creating `URLReqeust` from `Request`.
    case requestError(Error)
    
    /// Error while creating `Request.Response` from `(Data, URLResponse)`.
    case responseError(Error)
}

