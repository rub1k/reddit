//
//  RecentViewModel.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 27.09.2020.
//

import Foundation

protocol RecentViewModelInput {}

protocol RecentViewModelOutput {
    var blogposts: [Blogpost] { get }
    var title: String { get }
}

protocol RecentViewModel: RecentViewModelInput, RecentViewModelOutput {}

struct DefaultRecentViewModel: RecentViewModel {
    // MARK: Private

    let blogpostDatabase: BlogpostDatabaseServiceSupportable

    // MARK: Output

    var title: String { return "Recent" }

    var blogposts: [Blogpost] {
        return blogpostDatabase.getAllRecent()
    }
}
