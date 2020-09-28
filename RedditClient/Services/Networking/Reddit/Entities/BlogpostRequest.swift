//
//  BlogpostRequest.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 27.09.2020.
//

import Foundation

struct BlogpostRequest: Codable {
    struct Constants {
        static let defaultPostsLimit = 50
    }

    let after: String
    let limit: Int

    init(after: String = "",
         limit: Int = Constants.defaultPostsLimit) {
        self.after = after
        self.limit = limit
    }

    enum CodingKeys: String, CodingKey {
        case after
        case limit
    }
}
