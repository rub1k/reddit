//
//  Listing.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 27.09.2020.
//

import Foundation

// MARK: - Listing

struct Listing: Codable {
    let kind: String
    let listingData: ListingData

    enum CodingKeys: String, CodingKey {
        case listingData = "data"
        case kind
    }
}

// MARK: - ListingData

struct ListingData: Codable {
    let modhash: String
    let dist: Int
    let blogposts: [BlogpostData]
    let after: String
    let before: String?

    enum CodingKeys: String, CodingKey {
        case modhash
        case dist
        case blogposts = "children"
        case after
        case before
    }
}

// MARK: - BlogpostData

struct BlogpostData: Codable, Equatable {
    let kind: String
    let data: Blogpost

    enum CodingKeys: String, CodingKey {
        case kind
        case data
    }
}
