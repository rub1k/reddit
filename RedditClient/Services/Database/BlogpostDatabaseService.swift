//
//  BlogpostDatabaseService.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 28.09.2020.
//

import CoreData
import Foundation

protocol BlogpostDatabaseDelegate: class {
    func databaseDidUpdate()
}

protocol BlogpostDatabaseServiceSupportable {
    var delegates: [BlogpostDatabaseDelegate] { get set }

    func addOrUpdate(_ model: Blogpost)
    func getAllRecent() -> [Blogpost]
}

class BlogpostDatabaseService: NSObject, BlogpostDatabaseServiceSupportable {
    var delegates = [BlogpostDatabaseDelegate]()

    // MARK: Private

    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: BlogpostEntity.entityName)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Load persistent store error \(error), \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    private lazy var fetchedResultController: NSFetchedResultsController<BlogpostEntity> = {
        let fetchRequest: NSFetchRequest<BlogpostEntity> = BlogpostEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor.instantiate(\.updateDate)]

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        do {
            try controller.performFetch()
        } catch {
            fatalError(error.localizedDescription)
        }
        return controller
    }()

    func addOrUpdate(_ model: Blogpost) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        if let blogpostDb = fetchedResultController.fetchedObjects?.filter({ $0.id == model.id }).first {
            updateDBModel(blogpostDb, model)
        } else {
            let blogpostDb = BlogpostEntity(context: backgroundContext)
            blogpostDb.id = model.id
            updateDBModel(blogpostDb, model)
        }

        save(on: backgroundContext)
    }

    func getAllRecent() -> [Blogpost] {
        if let objects = fetchedResultController.fetchedObjects {
            return objects.map({ mapToObject(blogpostDB: $0) })
        }
        return []
    }
}

// MARK: - Private

private extension BlogpostDatabaseService {
    func save(on context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try? context.save()
            }
        }
    }

    // MARK: This mappers should be moved to models with generic protocol

    func mapToObject(blogpostDB: BlogpostEntity) -> Blogpost {
        return Blogpost(id: blogpostDB.id,
                        thumbnail: blogpostDB.thumbnail,
                        url: blogpostDB.url,
                        author: blogpostDB.author,
                        title: blogpostDB.title,
                        created: blogpostDB.created,
                        commentsCount: Int(blogpostDB.commentsCount),
                        permalink: blogpostDB.permalink,
                        thumbnailWidth: blogpostDB.thumbnailWidth,
                        thumbnailHeight: blogpostDB.thumbnailHeight,
                        articleText: blogpostDB.articleText)
    }

    func updateDBModel(_ blogpostDb: BlogpostEntity, _ model: Blogpost) {
        blogpostDb.thumbnailHeight = model.thumbnailHeight ?? .zero
        blogpostDb.permalink = model.permalink
        blogpostDb.thumbnailWidth = model.thumbnailWidth ?? .zero
        blogpostDb.commentsCount = Int64(model.commentsCount)
        blogpostDb.created = model.created
        blogpostDb.title = model.title
        blogpostDb.author = model.author
        blogpostDb.url = model.url
        blogpostDb.thumbnail = model.thumbnail
        blogpostDb.articleText = model.articleText
        blogpostDb.updateDate = Date()
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension BlogpostDatabaseService: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegates.forEach { $0.databaseDidUpdate() }
    }
}

// MARK: - NSSortDescriptor

private extension NSSortDescriptor {
    static func instantiate<Value>(_ keyPath: WritableKeyPath<BlogpostEntity, Value>,
                                   ascending: Bool = false) -> NSSortDescriptor
    {
        let keyString = NSExpression(forKeyPath: keyPath).keyPath
        return NSSortDescriptor(key: keyString, ascending: ascending)
    }
}
