//
//  NetworkService.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 26.09.2020.
//

import Foundation

protocol Cancelable {
    func cancel()
}

extension URLSessionDataTask: Cancelable {}

protocol NetworkRequestable {
    @discardableResult
    func performRequest<T>(router: NetworkRoutable,
                           completion: @escaping NetworkResult<T>) -> Cancelable
}

class NetworkService: NSObject, NetworkRequestable, URLSessionDelegate {
    private var session: URLSession
    private var builder: RequestBuildable
    private var mapper: NetworkResponseMappable

    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.default),
         builder: RequestBuildable = RedditApiRequestBuilder(),
         mapper: NetworkResponseMappable = RedditResponseMapper()) {
        self.session = session
        self.builder = builder
        self.mapper = mapper
    }

    @discardableResult
    func performRequest<T>(router: NetworkRoutable,
                           completion: @escaping NetworkResult<T>) -> Cancelable {
        let task = session.dataTask(with: builder.buildRequest(for: router)) { [weak self] data, response, error in
            self?.mapper.map(from: (data, response, error), completion: { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            })
        }

        task.resume()

        return task
    }
}
