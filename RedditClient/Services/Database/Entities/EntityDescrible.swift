//
//  EntityDescrible.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 28.09.2020.
//

import Foundation
import CoreData

protocol EntityDescrible {
    static var entityName: String { get }
}

extension EntityDescrible {
    static var entityName: String {
        return String(describing: self)
    }
}

extension NSManagedObject: EntityDescrible {}
