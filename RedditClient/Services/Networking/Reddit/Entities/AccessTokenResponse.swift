//
//  AccessTokenResponse.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 26.09.2020.
//

import Foundation

// MARK: - AccessTokenResponse

struct AccessTokenResponse: Codable {
    let accessToken: String
    let tokenType: String
    let deviceid: String
    let expiresIn: TimeInterval
    let scope: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case deviceid = "device_id"
        case expiresIn = "expires_in"
        case scope
    }
}
