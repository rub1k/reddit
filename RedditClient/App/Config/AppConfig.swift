//
//  AppConfig.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 26.09.2020.
//

import Foundation

enum AppConfigKey {
    case redditAPIPath
    case redditAPIKey
    case redditOauthUrl
    case redditDomain

    var key: String {
        switch self {
        case .redditAPIPath:
            return "REDDIT_API_PATH"
        case .redditAPIKey:
            return "REDDIT_KEY"
        case .redditOauthUrl:
            return "REDDIT_OAUTH_URL"
        case .redditDomain:
            return "REDDIT_DOMAIN"
        }
    }
}

struct AppConfig {
    static func infoForKey(_ config: AppConfigKey) -> String {
        guard let configKey = stringKey(config.key) else {
            fatalError("\(config.key) is not exist. Check info.plist with xcconfig.")
        }
        return configKey
    }

    static func stringKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }
}
