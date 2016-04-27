// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to App.swift instead.

import Foundation
import CoreData

public enum AppAttributes: String {
    case appId = "appId"
    case name = "name"
}

public enum AppRelationships: String {
    case details = "details"
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
    var name: String?

    // MARK: - Relationships

    @NSManaged public
    var details: AppDetails?

}

