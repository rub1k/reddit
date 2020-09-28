//
//  RequestBuildable.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 26.09.2020.
//

import Foundation

protocol RequestBuildable {
    var baseURL: URL { get }
    func buildRequest(for router: NetworkRoutable) -> URLRequest
}

extension RequestBuildable {
    func buildRequest(for router: NetworkRoutable) -> URLRequest {
        var url = baseURL
        url.appendPathComponent(router.path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method.rawValue
        urlRequest.addHeaders(router.headers)
        urlRequest.addParams(router.parameters)
        return urlRequest
    }
}
