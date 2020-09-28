//
//  RedditNetworkError.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 27.09.2020.
//

import Foundation

struct RedditErrorInfo: LocalizedError, Decodable {
    let message: String
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case message
        case statusCode = "error"
    }
}
