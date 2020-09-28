//
//  PostListViewModel.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 22.09.2020.
//

import UIKit

protocol PostListViewModelInput {
    func viewDidLoad()
    
    func loadNextPage()
    func resetAndLoadPage()
    func didSelectItem(at index: Int)
    func willDisplayRow(at index: Int)
}

protocol PostListViewModelOutput {
    var nextPageDidLoad: (([Blogpost]) -> Void)? { get set }
    var nextPageDidLoadError: ((Error) -> Void)? { get set }
    var title: String { get }
}

protocol PostListViewModel: PostListViewModelInput, PostListViewModelOutput {}

class DefaultPostListViewModel: PostListViewModel {
    struct Constants {
        static let paginationItemGap = 20
    }
    
    // MARK: Private
    
    private var databaseService: BlogpostDatabaseServiceSupportable
    private var postLoader: RedditPostLoadable
    private var isLoading = false
    
    private var blogposts: [Blogpost] = [] {
        didSet {
            nextPageDidLoad?(blogposts)
        }
    }

    // MARK: Output
    
    var nextPageDidLoad: (([Blogpost]) -> Void)?
    var nextPageDidLoadError: ((Error) -> Void)?
    var title: String { return "Posts" }

    // MARK: Initialization
    
    init(databaseService: BlogpostDatabaseServiceSupportable,
         postLoader: RedditPostLoadable = RedditPostLoader())
    {
        self.databaseService = databaseService
        self.postLoader = postLoader
    }

    // MARK: - PostListViewModelInput
    
    func viewDidLoad() {
        loadNextPage()
    }
    
    func resetAndLoadPage() {
        isLoading = true
        blogposts.removeAll()
        postLoader.fetchPosts(completion: handleResponse())
    }
    
    fileprivate func handleResponse() -> (NetworkResult<Listing>) {
        return { [weak self] result in
            guard let self = self else { return }
            defer { self.isLoading = false }
            switch result {
            case .success(let model):
                let posts = model.listingData.blogposts.map({ $0.data })
                self.blogposts.append(contentsOf: posts)
            case .failure(let error):
                self.nextPageDidLoadError?(error)
            }
        }
    }
    
    func loadNextPage() {
        isLoading = true
        postLoader.fetchNextPosts(completion: handleResponse())
    }
    
    func didSelectItem(at index: Int) {
        databaseService.addOrUpdate(blogposts[index])
    }
 
    func willDisplayRow(at index: Int) {
        guard !isLoading, blogposts.count - index <= Constants.paginationItemGap else { return }
        loadNextPage()
    }
}
