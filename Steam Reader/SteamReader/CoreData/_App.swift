// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to App.swift instead.

import Foundation
import CoreData

public enum AppAttributes: String {
    case appId = "appId"
    case comingSoon = "comingSoon"
    case name = "name"
    case newRelease = "newRelease"
    case special = "special"
    case subscribed = "subscribed"
    case topSeller = "topSeller"
    case type = "type"
}

public enum AppRelationships: String {
    case details = "details"
    case newsItems = "newsItems"
}

public class _App: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "App"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _App.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var appId: String?

    @NSManaged public
    var comingSoon: NSNumber?

    @NSManaged public
    var name: String?

    @NSManaged public
    var newRelease: NSNumber?

    @NSManaged public
    var special: NSNumber?

    @NSManaged public
    var subscribed: NSNumber?

    @NSManaged public
    var topSeller: NSNumber?

    @NSManaged public
    var type: NSNumber?

    // MARK: - Relationships

    @NSManaged public
    var details: AppDetails?

    @NSManaged public
    var newsItems: NSSet

}

extension _App {

    func addNewsItems(objects: NSSet) {
        let mutable = self.newsItems.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as Set<NSObject>)
        self.newsItems = mutable.copy() as! NSSet
    }

    func removeNewsItems(objects: NSSet) {
        let mutable = self.newsItems.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as Set<NSObject>)
        self.newsItems = mutable.copy() as! NSSet
    }

    func addNewsItemsObject(value: NewsItem) {
        let mutable = self.newsItems.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.newsItems = mutable.copy() as! NSSet
    }

    func removeNewsItemsObject(value: NewsItem) {
        let mutable = self.newsItems.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.newsItems = mutable.copy() as! NSSet
    }

}

