//
//  UIAlertController+Fabric.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 28.09.2020.
//

import UIKit

extension UIAlertController {
    static func imageSaveAlert(okHandler: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: "", message: "Do you want to save image?", preferredStyle: .actionSheet)

        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            okHandler?()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(okAction)
        alert.addAction(cancelAction)
        return alert
    }

    static func infoAlert(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
}
