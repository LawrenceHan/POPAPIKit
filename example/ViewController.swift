//
//  ViewController.swift
//  example
//
//  Created by Hanguang on 2017/8/6.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

//
//  ViewController.swift
//  example
//
//  Created by Hanguang on 2017/8/3.
//  Copyright © 2017年 Yosuke Ishikawa. All rights reserved.
//

import UIKit
import POPAPIKit

// MARK: - First Level
extension RequestSerializable where Self: POPAPIKit.Request {
    func buildURLRequest() throws -> URLRequest {
        print("Extension: \(#function)")
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
}

extension Interceptable {
    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        print("Extension: \(#function)")
        return urlRequest
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        print("Extension: \(#function)")
        guard 200..<300 ~= urlResponse.statusCode else {
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
        return object
    }
}

extension ErrorHandleable {
    func handle(error: SessionTaskError) {
        print("Extension: \(#function)")
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rateLimitRequest = GitHubAPI.GetRateLimitRequest()
//        print(rateLimitRequest.curl)
        APIKit.send(rateLimitRequest) { result in
            switch result {
            case .success(let rateLimit):
                print("count: \(rateLimit.count)")
                print("reset: \(rateLimit.resetDate)")
                
            case .failure(let error):
                print("error: \(error)")
            }
        }
        
//        let searchRequest = GitHubAPI.SearchRepositoriesRequest(query: "swift")
//        APIKit.send(searchRequest) { result in
//            switch result {
//            case .success(let response):
//                print(response)
//            case .failure(let error):
//                print("error: \(error)")
//            }
//        }
    }
}
