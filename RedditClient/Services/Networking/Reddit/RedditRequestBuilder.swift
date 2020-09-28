//
//  RedditRequestBuilder.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 26.09.2020.
//

import Foundation

struct RedditApiRequestBuilder: RequestBuildable {
    var baseURL: URL {
        let urlString = AppConfig.infoForKey(.redditDomain) + AppConfig.infoForKey(.redditAPIPath)
        guard let baseURL = URL(string: urlString) else {
            fatalError("No path components in Router")
        }
        return baseURL
    }
}

struct RedditOauthRequestBuilder: RequestBuildable {
    var baseURL: URL {
        guard let baseURL = URL(string: AppConfig.infoForKey(.redditOauthUrl)) else {
            fatalError("No path components in Router")
        }
        return baseURL
    }
}
