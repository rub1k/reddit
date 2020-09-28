//
//  BlogpostEntity+CoreDataProperties.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 28.09.2020.
//
//

import Foundation
import CoreData


extension BlogpostEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlogpostEntity> {
        return NSFetchRequest<BlogpostEntity>(entityName: "BlogpostEntity")
    }

    @NSManaged public var author: String
    @NSManaged public var commentsCount: Int64
    @NSManaged public var created: Double
    @NSManaged public var id: String
    @NSManaged public var permalink: String
    @NSManaged public var thumbnail: String
    @NSManaged public var thumbnailHeight: Float
    @NSManaged public var thumbnailWidth: Float
    @NSManaged public var title: String
    @NSManaged public var url: String
    @NSManaged public var updateDate: Date
    @NSManaged public var articleText: String

}

extension BlogpostEntity : Identifiable {

}
