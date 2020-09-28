//
//  AccessTokenRequest.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 26.09.2020.
//

import Foundation

// MARK: - TokenRequestModel

struct AccessTokenRequest: Codable {
    let grantType: String = "https://oauth.reddit.com/grants/installed_client"
    let deviceId: String = UUID().uuidString

    enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case deviceId = "device_id"
    }
}
