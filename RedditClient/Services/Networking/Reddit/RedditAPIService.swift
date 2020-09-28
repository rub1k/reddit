//
//  RedditNetworkService.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 26.09.2020.
//

import Foundation

protocol RedditAPIServiceSupportable {
    func createAccessToken(completion: @escaping NetworkResult<AccessTokenResponse>)
}

protocol RedditAurhorizedServiceSupportable {
    func fetchPosts(_ model: BlogpostRequest, completion: @escaping NetworkResult<Listing>)
}

// MARK: - RedditAPIServiceSupportable

class RedditAPIService: RedditAPIServiceSupportable {
    let networkService: NetworkService

    init(networkService: NetworkService = NetworkService(builder: RedditApiRequestBuilder())) {
        self.networkService = networkService
    }

    func createAccessToken(completion: @escaping NetworkResult<AccessTokenResponse>) {
        let router = AccessTokenRouter.getNewAccessToken
        networkService.performRequest(router: router, completion: completion)
    }
}

// MARK: - RedditAurhorizedServiceSupportable

class RedditAurhorizedService: RedditAurhorizedServiceSupportable {
    let networkService: NetworkService

    init(networkService: NetworkService = NetworkService(builder: RedditOauthRequestBuilder())) {
        self.networkService = networkService
    }

    func fetchPosts(_ model: BlogpostRequest, completion: @escaping NetworkResult<Listing>) {
        let router = BlogpostRouter.posts(post: model)
        networkService.performRequest(router: router, completion: completion)
    }
}
