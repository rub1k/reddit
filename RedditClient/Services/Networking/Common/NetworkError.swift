//
//  NetworkError.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 26.09.2020.
//

import Foundation

protocol NetworkError: Decodable, LocalizedError {}

enum GenericNetworkError: LocalizedError {
    case unknown(description: String = "")
    case noInternetConnection
    case responseFormat
    case server(description: Error? = nil)

    var failureReason: String? {
        switch self {
        case .unknown:
            return "Something went wrong"
        case .noInternetConnection:
            return "No internet connection"
        case .server:
            return ""
        case .responseFormat:
            return "Incorrect response"
        }
    }

    var localizedDescription: String? {
        switch self {
        case .unknown(let description):
            return description
        case .noInternetConnection:
            return "Check internet connection"
        case .server(let error):
            return error?.localizedDescription
        case .responseFormat:
            return "Rsponse format is incorrect"
        }
    }
}
