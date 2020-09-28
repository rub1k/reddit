//
//  NetworkStatusCode.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 26.09.2020.
//

import Foundation

enum HTTPStatusCode {
    enum ResponseType {
        case informational
        case success
        case redirection
        case clientError
        case serverError
        case undefined
    }

    static func responseTypeFrom(code: Int) -> ResponseType {
        switch code {
        case 100..<200:
            return .informational
        case 200..<300:
            return .success
        case 300..<400:
            return .redirection
        case 400..<500:
            return .clientError
        case 500..<600:
            return .serverError
        default:
            return .undefined
        }
    }
}

// MARK: - Extension

extension HTTPURLResponse {
    var responseType: HTTPStatusCode.ResponseType {
        return HTTPStatusCode.responseTypeFrom(code: statusCode)
    }
}
