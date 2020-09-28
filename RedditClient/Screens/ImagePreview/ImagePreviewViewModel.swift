//
//  ImagePreviewViewModel.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 27.09.2020.
//

import Foundation

protocol ImagePreviewViewModelInput {
    var imageURL: URL? { get set }
}

protocol ImagePreviewViewModel: ImagePreviewViewModelInput {}

struct DefaultImagePreviewViewModel: ImagePreviewViewModel {
    var imageURL: URL?
}
