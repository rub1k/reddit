//
//  TableCellRegistrator.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 22.09.2020.
//

import Foundation
import UIKit

class TableCellRegistrator {
    private var registeredCells = Set<String>()
    private weak var tableView: UITableView?
    
    init(tableView: UITableView?) {
        self.tableView = tableView
    }
    
    func register(cell: AnyClass, forCellReuseIdentifier reuseIdentifier: String) {
        if registeredCells.contains(reuseIdentifier) { return }
        
        if tableView?.dequeueReusableCell(withIdentifier: reuseIdentifier) != nil {
            registeredCells.insert(reuseIdentifier)
            return
        }
        
        let bundle = Bundle(for: cell)

        if let _ = bundle.path(forResource: reuseIdentifier, ofType: "nib") {
            let nib = UINib(nibName: reuseIdentifier, bundle: bundle)
            tableView?.register(nib, forCellReuseIdentifier: reuseIdentifier)
        } else {
            tableView?.register(cell, forCellReuseIdentifier: reuseIdentifier)
        }
        
        registeredCells.insert(reuseIdentifier)
    }
}
