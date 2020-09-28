//
//  NetworkRoutable.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 26.09.2020.
//

import Foundation

enum RequestParametrizable {
    case query(model: Encodable)
    case body(model: Encodable)
    case urlForm(model: Encodable)
}

protocol NetworkRoutable {
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: [HTTPHeader] { get }
    var parameters: RequestParametrizable { get }
}
