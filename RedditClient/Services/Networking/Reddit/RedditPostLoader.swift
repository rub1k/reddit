//
//  RedditPostLoader.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 27.09.2020.
//

import Foundation

protocol RedditPostLoadable {
    var tokenStorage: AuthStorable { get }
    var authorizedService: RedditAurhorizedServiceSupportable { get }
    var apiService: RedditAPIServiceSupportable { get }
    
    func fetchNextPosts(completion: @escaping NetworkResult<Listing>)
    func fetchPosts(completion: @escaping NetworkResult<Listing>)
}

class RedditPostLoader: RedditPostLoadable {
    // MARK: RedditPostLoadable
    
    var tokenStorage: AuthStorable
    var authorizedService: RedditAurhorizedServiceSupportable
    var apiService: RedditAPIServiceSupportable
    
    // MARK: Private
    
    private let group = DispatchGroup()
    private var error: Error?
    private var postResponse: Listing?
    private var nextDataLink: String = ""
    
    // MARK: Initialization
    //mark - UserDefaults storage it's just for test
    init(tokenStorage: AuthStorable = AuthStorage(dataSaver: UserDefaults.standard),
         authorizedService: RedditAurhorizedServiceSupportable = RedditAurhorizedService(),
         apiService: RedditAPIServiceSupportable = RedditAPIService()) {
        self.tokenStorage = tokenStorage
        self.authorizedService = authorizedService
        self.apiService = apiService
    }
    
    // MARK: RedditPostLoadable
    func fetchPosts(completion: @escaping NetworkResult<Listing>) {
        nextDataLink = ""
        fetchNextPosts(completion: completion)
    }

    func fetchNextPosts(completion: @escaping NetworkResult<Listing>) {
        DispatchQueue.global().async {
            self.startRequests()
            self.addExecutionNotifier(completion: completion)
        }
    }
}

private extension RedditPostLoader {
    func startRequests() {
        if tokenStorage.isExpire {
            performTokenItem()
            group.wait()
        }
        performPostItem()
    }
    
    func addExecutionNotifier(completion: @escaping NetworkResult<Listing>) {
        group.notify(queue: .main) {
            if let listing = self.postResponse {
                completion(.success(listing))
            } else if let error = self.error {
                completion(.failure(error))
            } else {
                completion(.failure(GenericNetworkError.unknown()))
            }
        }
    }

    func performTokenItem() {
        group.enter()
        apiService.createAccessToken { [weak self] result in
            guard let self = self else { return }
            defer { self.group.leave() }
            switch result {
            case .success(let response):
                self.tokenStorage.saveToken(response.accessToken,
                                            expireAfter: response.expiresIn)
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    private func performPostItem() {
        group.enter()
        authorizedService.fetchPosts(BlogpostRequest(after: nextDataLink)) { [weak self] result in
            guard let self = self else { return }
            defer { self.group.leave() }
            switch result {
            case .success(let response):
                self.postResponse = response
                self.nextDataLink = response.listingData.after
            case .failure(let error):
                self.error = error
            }
        }
    }
}
