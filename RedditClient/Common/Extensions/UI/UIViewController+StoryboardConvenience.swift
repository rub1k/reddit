//
//  UIViewController+StoryboardConvenience.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 22.09.2020.
//

import Foundation
import UIKit

extension UIViewController {
    class func instantiate() -> Self {
        return _instantiate()
    }
}

extension ViewModelConfigurable where Self: UIViewController {
    static func instantiate(with viewModel: Self.ViewModel) -> Self {
        return _viewModelConfigurableInstance(viewModel: viewModel)
    }
}

// MARK: - Private

private extension UIViewController {
    
    static private var bundleIdentifier: String {
        guard let identifier = Bundle.main.bundleIdentifier else {
            fatalError("Check bundle identifier")
        }
        return identifier
    }
    
    class func _instantiate<T: UIViewController>() -> T {
        let name = String(describing: type(of: T.self)).components(separatedBy: ".").first!
        let bundle = Bundle(identifier: bundleIdentifier)
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        let controller = storyboard.instantiateViewController(withIdentifier: name) as! T
        return controller
    }
    
    class func _viewModelConfigurableInstance<T: UIViewController & ViewModelConfigurable>(viewModel: T.ViewModel) -> T {
        let controller: T = _instantiate()
        controller.configure(with: viewModel)
        return controller
    }
}
