//
//  ConfigurableView.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 22.09.2020.
//

import Foundation

protocol ConfigurableView {
    associatedtype ModelType

    func configure(with model: ModelType)
}

protocol ViewModelConfigurable: ConfigurableView {
    associatedtype ViewModel

    var viewModel: ViewModel! { get }
    func configure(with model: ViewModel)
}
