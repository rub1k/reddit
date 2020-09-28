//
//  PostListViewController.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 22.09.2020.
//

import UIKit

class PostListViewController: UIViewController, ViewModelConfigurable {
    weak var factory: ModuleFactoryBuildable!
    
    // MARK: ViewModelConfigurable
    
    var viewModel: PostListViewModel!

    func configure(with viewModel: PostListViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    // MARK: Outlets
    
    @IBOutlet private weak var noDataLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = dataSource
            refreshControl.addTarget(self, action: #selector(self.refresh(_:)),
                                     for: .valueChanged)
            tableView.addSubview(refreshControl)
        }
    }
    
    // MARK: Private
    
    private let dataSource = ArrayTableViewDataSource<Blogpost, PostTableViewCell>()
    var refreshControl = UIRefreshControl()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
        viewModel.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - TableViewDelegate

extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath)
    {
        viewModel.willDisplayRow(at: indexPath.row)
        if let cell = cell as? PostTableViewCell {
            cell.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewModel = dataSource.objectAtIndexPath(indexPath)
        guard let permalink = viewModel.fullPermalink else { return }
        self.viewModel.didSelectItem(at: indexPath.row)
        showPermalink(permalink)
    }
}

// MARK: - PostTableViewCellDelegate

extension PostListViewController: PostTableViewCellDelegate {
    func imageDidPress(at cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let viewModel = dataSource.objectAtIndexPath(indexPath)
        showImagePreview(with: viewModel.imageURL)
    }
}

// MARK: - Private

private extension PostListViewController {
    func setupUI() {
        activityIndicatorAnimate(true)
        title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func showImagePreview(with url: URL?) {
        let imageViewer = factory.makeImagePreviewModule(with: url)
        present(imageViewer, animated: true)
    }
    
    func showPermalink(_ permalink: URL) {
        let webPreview = factory.makeWebPreviewModule(with: permalink)
        present(webPreview, animated: true)
    }
    
    func bind() {
        viewModel.nextPageDidLoad = { [weak self] data in
            guard let self = self else { return }
            self.dataSource.updateWith(items: data)
            self.tableView.reloadData()
            self.hideLoaders()
        }
        
        viewModel.nextPageDidLoadError = { [weak self] error in
            guard let self = self else { return }
            let alert = UIAlertController.infoAlert(title: "Error",
                                                    message: error.localizedDescription)
            self.present(alert, animated: true)
            self.hideLoaders()
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.resetAndLoadPage()
    }
    
    private func hideLoaders() {
        noDataLabel.isHidden = !dataSource.items.isEmpty
        refreshControl.endRefreshing()
        activityIndicatorAnimate(false)
    }
}
