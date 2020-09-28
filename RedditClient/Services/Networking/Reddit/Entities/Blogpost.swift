//
//  Blogpost.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 27.09.2020.
//

import Foundation

struct Blogpost: Identifiable, Equatable, Codable {
    let id: String
    let thumbnail: String
    let url: String
    let author: String
    let title: String
    let created: TimeInterval
    let commentsCount: Int
    let permalink: String
    let thumbnailWidth: Float?
    let thumbnailHeight: Float?
    let articleText: String

    enum CodingKeys: String, CodingKey {
        case commentsCount = "num_comments"
        case thumbnailWidth = "thumbnail_width"
        case thumbnailHeight = "thumbnail_height"
        case articleText = "selftext"
        case url
        case thumbnail
        case author
        case title
        case created
        case permalink
        case id
    }
}

// MARK: - Extension

extension Blogpost {
    var isThumbnailPresent: Bool {
        return (thumbnailWidth != nil && thumbnailHeight != nil) ||
            (thumbnailWidth == .zero && thumbnailHeight == .zero)
    }

    var imageURL: URL? {
        URL(string: url)
    }

    var fullPermalink: URL? {
        URL(string: AppConfig.infoForKey(.redditDomain) + permalink)
    }

    var thumbnailURL: URL? {
        URL(string: thumbnail)
    }

    var createdDate: Date {
        return Date(timeIntervalSince1970: created)
    }

    func formattedCreatedDate() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: createdDate, relativeTo: Date())
    }
}
