//
//  NetworHTTPHeader.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 26.09.2020.
//

import Foundation

struct HTTPHeader: Hashable {
    public let name: String
    public let value: String

    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

extension HTTPHeader {
    public static func authorization(bearerToken: String) -> HTTPHeader {
        return authorization(value: "Bearer \(bearerToken)")
    }

    public static func authorization(basic: String) -> HTTPHeader {
        return authorization(value: "Basic \(basic)")
    }

    public static func authorization(value: String) -> HTTPHeader {
        HTTPHeader(name: "Authorization", value: value)
    }

    public static func formEncoded() -> HTTPHeader {
        HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded")
    }
}
