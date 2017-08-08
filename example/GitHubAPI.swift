//
//  GitHubAPI.swift
//  POPAPIKit
//
//  Created by Hanguang on 2017/8/6.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

import Foundation
import POPAPIKit
import Himotoki

protocol GitHubRequest: Request {}

extension GitHubRequest {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    // MARK: - Second Level
    func buildURLRequest() throws -> URLRequest {
        print("Sub-Protocol: \(#function)")
        let url = path.isEmpty ? baseURL : baseURL.appendingPathComponent(path)
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw RequestError.invalidBaseURL(baseURL)
        }
        
        var urlRequest = URLRequest(url: url)
        
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            components.percentEncodedQuery = URLEncodedSerialization.string(from: queryParameters)
        }
        
        if let bodyParameters = bodyParameters {
            urlRequest.setValue(bodyParameters.contentType, forHTTPHeaderField: "Content-Type")
            
            switch try bodyParameters.buildEntity() {
            case .data(let data):
                urlRequest.httpBody = data
                
            case .inputStream(let inputStream):
                urlRequest.httpBodyStream = inputStream
            }
        }
        
        urlRequest.url = components.url
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(dataParser.contentType, forHTTPHeaderField: "Accept")
        
        headerFields.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return (try intercept(urlRequest: urlRequest) as URLRequest)
    }
    
    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        print("Sub-Protocol: \(#function)")
        return urlRequest
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        print("Sub-Protocol: \(#function)")
        guard 200..<300 ~= urlResponse.statusCode else {
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
        return object
    }
    
    func handle(error: SessionTaskError) {
        print("Sub-Protocol: \(#function)")
    }
}

extension GitHubRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response.decodeValue(object)
    }
}

final class GitHubAPI {
    struct GetRateLimitRequest: GitHubRequest {
        typealias Response = RateLimit
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/rate_limit"
        }
        
        // MARK: - Third Level
        func buildURLRequest() throws -> URLRequest {
            print("Final-Protocol: \(#function)")
            let url = path.isEmpty ? baseURL : baseURL.appendingPathComponent(path)
            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                throw RequestError.invalidBaseURL(baseURL)
            }
            
            var urlRequest = URLRequest(url: url)
            
            if let queryParameters = queryParameters, !queryParameters.isEmpty {
                components.percentEncodedQuery = URLEncodedSerialization.string(from: queryParameters)
            }
            
            if let bodyParameters = bodyParameters {
                urlRequest.setValue(bodyParameters.contentType, forHTTPHeaderField: "Content-Type")
                
                switch try bodyParameters.buildEntity() {
                case .data(let data):
                    urlRequest.httpBody = data
                    
                case .inputStream(let inputStream):
                    urlRequest.httpBodyStream = inputStream
                }
            }
            
            urlRequest.url = components.url
            urlRequest.httpMethod = method.rawValue
            urlRequest.setValue(dataParser.contentType, forHTTPHeaderField: "Accept")
            
            headerFields.forEach { key, value in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
            
            return (try intercept(urlRequest: urlRequest) as URLRequest)
        }
        
        func intercept(urlRequest: URLRequest) throws -> URLRequest {
            print("Final-Protocol: \(#function)")
            return urlRequest
        }
        
        func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
            print("Final-Protocol: \(#function)")
            guard 200..<300 ~= urlResponse.statusCode else {
                throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
            }
            return object
        }
        
        func handle(error: SessionTaskError) {
            print("Final-Protocol: \(#function)")
        }
    }
    
    struct SearchRepositoriesRequest: GitHubRequest {
        let query: String
        
        // MARK: Request
        typealias Response = SearchResponse<Repository>
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/search/repositories"
        }
        
        var parameters: Any? {
            return ["q": query]
        }
    }
}

struct RateLimit: Decodable {
    let count: Int
    let resetDate: Date
    
    init(count: Int, resetDate: TimeInterval) {
        self.count = count
        self.resetDate = Date(timeIntervalSince1970: resetDate)
    }
    
    static func decode(_ e: Extractor) throws -> RateLimit {
        return try RateLimit(
            count: e <| ["rate", "limit"],
            resetDate: e <| ["rate", "reset"]
        )
    }
}

struct Repository: Decodable {
    let id: Int64
    let name: String
    
    static func decode(_ e: Extractor) throws -> Repository {
        return try Repository(
            id: e.value("id"),
            name: e.value("name"))
    }
}

struct SearchResponse<Item: Decodable>: Decodable {
    let items: [Item]
    let totalCount: Int
    
    static func decode(_ e: Extractor) throws -> SearchResponse {
        return try SearchResponse(
            items: e.array("items"),
            totalCount: e.value("total_count"))
    }
}
