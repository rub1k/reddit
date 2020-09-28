//
//  TabBarController.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 27.09.2020.
//

import SafariServices
import UIKit

class TabBarController: UITabBarController {
    // MARK: Private

    private let moduleFactory = ModuleFactory()

    // MARK: Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setViewControllers([moduleFactory.makePostListModule(),
                            moduleFactory.makeRecentListModule()], animated: false)
    }
}
