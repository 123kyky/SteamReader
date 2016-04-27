// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NewsItem.swift instead.

import Foundation
import CoreData

public enum NewsItemAttributes: String {
    case author = "author"
    case contents = "contents"
    case date = "date"
    case feedLabel = "feedLabel"
    case feedName = "feedName"
    case gid = "gid"
    case isExternalURL = "isExternalURL"
    case title = "title"
    case url = "url"
}

public enum NewsItemRelationships: String {
    case app = "app"
}

public class _NewsItem: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "NewsItem"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _NewsItem.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var author: String?

    @NSManaged public
    var contents: String?

    @NSManaged public
    var date: NSDate?

    @NSManaged public
    var feedLabel: String?

    @NSManaged public
    var feedName: String?

    @NSManaged public
    var gid: String?

    @NSManaged public
    var isExternalURL: NSNumber?

    @NSManaged public
    var title: String?

    @NSManaged public
    var url: String?

    // MARK: - Relationships

    @NSManaged public
    var app: NSOrderedSet

}

extension _NewsItem {

    func addApp(objects: NSOrderedSet) {
        let mutable = self.app.mutableCopy() as! NSMutableOrderedSet
        mutable.unionOrderedSet(objects)
        self.app = mutable.copy() as! NSOrderedSet
    }

    func removeApp(objects: NSOrderedSet) {
        let mutable = self.app.mutableCopy() as! NSMutableOrderedSet
        mutable.minusOrderedSet(objects)
        self.app = mutable.copy() as! NSOrderedSet
    }

    func addAppObject(value: AppDetails) {
        let mutable = self.app.mutableCopy() as! NSMutableOrderedSet
        mutable.addObject(value)
        self.app = mutable.copy() as! NSOrderedSet
    }

    func removeAppObject(value: AppDetails) {
        let mutable = self.app.mutableCopy() as! NSMutableOrderedSet
        mutable.removeObject(value)
        self.app = mutable.copy() as! NSOrderedSet
    }

}

