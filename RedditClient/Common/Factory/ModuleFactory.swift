//
//  ModuleFactory.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 22.09.2020.
//

import SafariServices
import UIKit

protocol ModuleFactoryBuildable: class {
    func makePostListModule() -> UIViewController
    func makeRecentListModule() -> UIViewController
    func makeImagePreviewModule(with url: URL?) -> UIViewController
    func makeWebPreviewModule(with permalink: URL) -> UIViewController
}

class ModuleFactory: ModuleFactoryBuildable {
    lazy var database: BlogpostDatabaseServiceSupportable = {
        BlogpostDatabaseService()
    }()

    func makePostListModule() -> UIViewController {
        let postListViewModel = DefaultPostListViewModel(databaseService: database)
        let postList = PostListViewController.instantiate(with: postListViewModel)
        postList.factory = self
        let postListNavigationController = UINavigationController(rootViewController: postList)
        return postListNavigationController
    }

    func makeRecentListModule() -> UIViewController {
        let recentViewModel = DefaultRecentViewModel(blogpostDatabase: database)
        let recentList = RecentViewController.instantiate(with: recentViewModel)
        let recentListNavigationController = UINavigationController(rootViewController: recentList)
        return recentListNavigationController
    }

    func makeImagePreviewModule(with url: URL?) -> UIViewController {
        let imagePreviewViewModel = DefaultImagePreviewViewModel(imageURL: url)
        return ImagePreviewViewController.instantiate(with: imagePreviewViewModel)
    }

    func makeWebPreviewModule(with permalink: URL) -> UIViewController {
        let safari = SFSafariViewController(url: permalink)
        safari.modalPresentationStyle = .popover
        safari.dismissButtonStyle = .cancel
        return safari
    }
}
