//
//  BlogpostRouter.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 27.09.2020.
//

import Foundation

enum BlogpostRouter {
    case posts(post: BlogpostRequest)
}

extension BlogpostRouter: NetworkRoutable {
    var storage: AuthStorable {
        AuthStorage(dataSaver: UserDefaults.standard)
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var path: String {
        "/top"
    }
    
    var headers: [HTTPHeader] {
        guard let token = storage.token else {
            return []
        }
        return [.authorization(bearerToken: token)]
    }
    
    var parameters: RequestParametrizable {
        switch self {
        case .posts(let post):
            return RequestParametrizable.query(model: post)
        }
    }
}
