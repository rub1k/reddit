//
//  ActivityIndicatorContainerView.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 28.09.2020.
//

import Foundation
import UIKit

open class ActivityIndicatorContainerView: UIView {
    private struct Constants {
        static let animationDuration = 0.2
    }

    // MARK: Public

    public var animating: Bool = false {
        didSet {
            if animating {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }

    // MARK: Private

    fileprivate var indicatorView: UIActivityIndicatorView!

    // MARK: - Lifecycle

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Private

    fileprivate func setup() {
        alpha = 1.0

        indicatorView = UIActivityIndicatorView(frame: .zero)
        indicatorView.style = .large
        indicatorView.tintColor = .darkGray
        addSubview(indicatorView)

        indicatorView.pinViewWidthAndHeight(width: 50.0, height: 50.0)
        indicatorView.pinViewToCenterOfSuperview()
    }

    fileprivate func startAnimating() {
        animate(show: true)
        indicatorView.startAnimating()
    }

    fileprivate func stopAnimating() {
        indicatorView.stopAnimating()
    }

    fileprivate func animate(show: Bool, completion: (() -> Void)? = nil) {
        let options = show ? UIView.AnimationOptions.curveEaseOut : UIView.AnimationOptions.curveEaseIn
        UIView.animate(withDuration: Constants.animationDuration,
                       delay: 0.0,
                       options: [UIView.AnimationOptions.beginFromCurrentState, options],
                       animations: {
                           self.alpha = show ? 1.0 : 0.0
                       }, completion: { _ in
                           completion?()
                       })
    }
}
