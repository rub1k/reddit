//
//  ImageView+Loadable.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 27.09.2020.
//

import UIKit

private let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func setImageWith(url: URL?, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let url = url else { return }
        if let cachedImage = imageCache.object(forKey: NSString(string: url.absoluteString)) {
            self.image = cachedImage
            completion(cachedImage, nil)
        } else {
            loadWithCache(url: url, completion: completion)
        }
    }
}

// MARK: - Private

private extension UIImageView {
    func loadWithCache(url: URL, completion: @escaping (UIImage?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                if let newImage = UIImage(data: data) {
                    imageCache.setObject(newImage, forKey: NSString(string: url.absoluteString))
                    completion(newImage, nil)
                } else {
                    completion(nil, error)                    
                }
            }
        }.resume()
    }
}
