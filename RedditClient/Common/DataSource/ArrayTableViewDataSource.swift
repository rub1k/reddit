//
//  OAuthViewController.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 22.09.2020.
//

import Foundation
import UIKit

class ArrayTableViewDataSource<Model: Equatable, CellType: UITableViewCell>: NSObject, UITableViewDataSource where CellType: ConfigurableView, CellType.ModelType == Model {
    
    // MARK: Private
    
    private var cellRegistrator: TableCellRegistrator!

    // MARK: Public

    private(set) var items = [Model]()

    // MARK: Public

    func updateWith(items: [Model]) {
        self.items = items
    }

    func append(items: [Model]) {
        self.items.append(contentsOf: items)
    }

    func objectAtIndexPath(_ indexPath: IndexPath) -> Model {
        return items[indexPath.row]
    }

    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count > 0 ? 1 : 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = CellType.reuseIdentifier

        if cellRegistrator == nil {
            cellRegistrator = TableCellRegistrator(tableView: tableView)
        }
        cellRegistrator.register(cell: CellType.self, forCellReuseIdentifier: reuseIdentifier)

        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CellType

        let model = items[indexPath.row]
        cell.configure(with: model)

        return cell
    }
}
