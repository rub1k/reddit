//
//  URLRequest+Builder.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 26.09.2020.
//

import Foundation

extension URLRequest {
    mutating func addHeaders(_ headers: [HTTPHeader]) {
        headers.forEach { self.setValue($0.value, forHTTPHeaderField: $0.name) }
    }

    mutating func addParams(_ prameter: RequestParametrizable) {
        switch prameter {
        case .query(let queryParams):
            addQueryParams(queryParams)
        case .body(let model):
            self.httpBody = model.asJSONData()
        case .urlForm(let params):
            self.httpBody = params.asUrlFormData()
        }
    }
}

// MARK: - Private

// MARK: URLRequest

private extension URLRequest {
    mutating func addQueryParams(_ parameters: [String: String]) {
        guard let url = self.url else { return }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.percentEncodedQuery = parameters.asQueryParameters
            self.url = urlComponents.url
        }
    }

    mutating func addQueryParams(_ parameters: Encodable) {
        guard let url = self.url, let query = parameters.asQuery() else { return }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.percentEncodedQuery = query
            self.url = urlComponents.url
        }
    }
}

// MARK: Dictionary

private extension Dictionary {
    var asQueryParameters: String {
        var parts = [String]()
        for (key, value) in self {
            guard let key = String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { break }
            guard let value = String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { break }
            parts.append(String(format: "%@=%@", key, value))
        }
        return parts.joined(separator: "&")
    }
}

// MARK: Encodable

private extension Encodable {
    func asJSONData() -> Data? { try? JSONEncoder().encode(self) }

    func asQuery() -> String? {
        guard let data = asJSONData(),
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else {
            return nil
        }
        return String(dictionary.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast())
    }

    func asUrlFormData() -> Data? {
        guard let data = asJSONData(),
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else {
            return nil
        }
        let jsonString = dictionary.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        return jsonString.data(using: .utf8, allowLossyConversion: true)
    }
}
