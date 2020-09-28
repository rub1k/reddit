//
//  UIVIewController+ActivityIndicator.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 28.09.2020.
//

import Foundation
import ObjectiveC
import UIKit

public protocol ActivityIndicatorPresenter {
    func activityIndicatorAnimate(_ animate: Bool)
}

extension UIViewController: ActivityIndicatorPresenter {}

private struct UIViewControllerActivityIndicatorConstants {
    static var ActivityIndicatorRuntimeKey = "ActivityIndicatorRuntimeKey"
}

extension ActivityIndicatorPresenter where Self: UIViewController {
    // MARK: - Private Variables

    func setActivityIndicator(_ view: ActivityIndicatorContainerView?) {
        objc_setAssociatedObject(self,
                                 &UIViewControllerActivityIndicatorConstants.ActivityIndicatorRuntimeKey,
                                 view,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func getActivityIndicator() -> ActivityIndicatorContainerView? {
        return objc_getAssociatedObject(self, &UIViewControllerActivityIndicatorConstants.ActivityIndicatorRuntimeKey) as? ActivityIndicatorContainerView
    }

    // MARK: - Public

    public func activityIndicatorAnimate(_ animate: Bool) {
        if let activityIndicator = getActivityIndicator() {
            if !animate {
                activityIndicator.animating = animate
                activityIndicator.removeFromSuperview()

                setActivityIndicator(nil)
            }
        } else {
            if animate {
                let activityIndicator = buildActivityIndicatorView()
                setActivityIndicator(activityIndicator)

                activityIndicator.animating = animate
            }
        }
    }

    // MARK: - Private

    private func buildActivityIndicatorView() -> ActivityIndicatorContainerView {
        let activityIndicator = ActivityIndicatorContainerView(frame: CGRect.zero)
        activityIndicator.backgroundColor = .white

        if self is UITableViewController {
            navigationController!.view.insertSubview(activityIndicator, belowSubview: navigationController!.navigationBar)
        } else {
            view.addSubview(activityIndicator)
        }

        activityIndicator.pinViewToEdgesOfSuperview()

        return activityIndicator
    }
}
