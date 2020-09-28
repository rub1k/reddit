//
//  RedditResponseMapper.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 26.09.2020.
//

import Foundation

class RedditResponseMapper: NetworkResponseMappable {
    func map<T: Decodable>(from dataResponse: NetworkSessionResponse,
                           completion: @escaping NetworkResult<T>) {
        guard Reachability.isConnectedToNetwork else {
            completion(.failure(GenericNetworkError.noInternetConnection))
            return
        }

        guard let response = (dataResponse.response as? HTTPURLResponse), let data = dataResponse.data else {
            completion(.failure(GenericNetworkError.responseFormat))
            return
        }

        if response.responseType == .serverError || response.responseType == .clientError {
            completion(.failure(GenericNetworkError.server()))
            return
        }

        if let error = dataResponse.error {
            completion(.failure(error))
        }

        if let model = try? JSONDecoder().decode(RedditErrorInfo.self, from: data) {
            completion(.failure(model))
        }

        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            completion(.success(model))
        } catch {
            completion(.failure(GenericNetworkError.responseFormat))
        }
    }
}
