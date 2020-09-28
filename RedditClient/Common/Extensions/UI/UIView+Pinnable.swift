//
//  UIView+Pinnable.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 28.09.2020.
//

import Foundation
import UIKit

extension UIView {
    public func pinViewToEdgesOfSuperview(leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        superview!.addConstraints([
            superview!.leftAnchor.constraint(equalTo: leftAnchor, constant: leftOffset),
            superview!.rightAnchor.constraint(equalTo: rightAnchor, constant: rightOffset),
            superview!.topAnchor.constraint(equalTo: topAnchor, constant: topOffset),
            superview!.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomOffset)
        ])
    }

    public func pinViewWidthAndHeight(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        superview!.addConstraints([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }

    public func pinViewToCenterOfSuperview(offsetX: CGFloat = 0.0, offsetY: CGFloat = 0.0) {
        translatesAutoresizingMaskIntoConstraints = false
        superview!.addConstraints([
            centerXAnchor.constraint(equalTo: superview!.centerXAnchor, constant: offsetX),
            centerYAnchor.constraint(equalTo: superview!.centerYAnchor, constant: offsetY)
        ])
    }
}
