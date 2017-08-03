//
//  Decodable.swift
//  POPAPIKit
//
//  Created by Hanguang on 2017/8/1.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

import Foundation

/// `Decodable` protocol provides inteface to transform JSON to Model
public protocol Decodable {
    /// Return `Self` that conform to Decodable.
    /// - Throws: `Error` when parser encountered invalid format.
    static func parse(json: Any) throws -> Self
}
