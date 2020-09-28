//
//  AccessTokenRouter.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 26.09.2020.
//

import Foundation

enum AccessTokenRouter {
    case getNewAccessToken
}

extension AccessTokenRouter: NetworkRoutable {
    var method: HTTPMethod {
        .post
    }

    var path: String {
        "/access_token"
    }

    var headers: [HTTPHeader] {
        return [.authorization(basic: AppConfig.infoForKey(.redditAPIKey)),
                .formEncoded()]
    }

    var parameters: RequestParametrizable {
        .urlForm(model: AccessTokenRequest())
    }
}
