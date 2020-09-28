//
//  RecentViewController.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 27.09.2020.
//

import UIKit

class RecentViewController: UIViewController, ViewModelConfigurable {
    // MARK: Outlets

    @IBOutlet private weak var noDataLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = dataSource
        }
    }

    // MARK: ViewModelConfigurable

    var viewModel: RecentViewModel!

    func configure(with viewModel: RecentViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Private

    private let dataSource = ArrayTableViewDataSource<Blogpost, RecentTableViewCell>()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dataSource.updateWith(items: viewModel.blogposts)
        tableView.reloadData()
        noDataLabel.isHidden = !dataSource.items.isEmpty
    }
}

// MARK: - Private

private extension RecentViewController {
    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = viewModel.title
    }
}
