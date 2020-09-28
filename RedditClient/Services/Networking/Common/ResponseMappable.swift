//
//  ResponseMappable.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 26.09.2020.
//

import Foundation

typealias NetworkSessionResponse = (data: Data?, response: URLResponse?, error: Error?)
typealias NetworkResult<T: Decodable> = (Swift.Result<T, Error>) -> Void

protocol NetworkResponseMappable {
    func map<T: Decodable>(from dataResponse: NetworkSessionResponse,
                           completion: @escaping NetworkResult<T>)
}
