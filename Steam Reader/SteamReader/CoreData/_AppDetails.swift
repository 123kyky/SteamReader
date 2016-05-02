// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AppDetails.swift instead.

import Foundation
import CoreData

public enum AppDetailsAttributes: String {
    case about = "about"
    case appId = "appId"
    case detailedDescription = "detailedDescription"
    case developers = "developers"
    case dlc = "dlc"
    case finalPrice = "finalPrice"
    case genres = "genres"
    case headerImage = "headerImage"
    case initialPrice = "initialPrice"
    case metacritic = "metacritic"
    case metacriticScore = "metacriticScore"
    case releaseDate = "releaseDate"
    case supportsLinux = "supportsLinux"
    case supportsMac = "supportsMac"
    case supportsWindows = "supportsWindows"
    case type = "type"
    case website = "website"
}

public enum AppDetailsRelationships: String {
    case app = "app"
}

public class _AppDetails: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "AppDetails"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _AppDetails.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var about: String?

    @NSManaged public
    var appId: String?

    @NSManaged public
    var detailedDescription: String?

    @NSManaged public
    var developers: AnyObject?

    @NSManaged public
    var dlc: AnyObject?

    @NSManaged public
    var finalPrice: NSNumber?

    @NSManaged public
    var genres: AnyObject?

    @NSManaged public
    var headerImage: String?

    @NSManaged public
    var initialPrice: NSNumber?

    @NSManaged public
    var metacritic: String?

    @NSManaged public
    var metacriticScore: NSNumber?

    @NSManaged public
    var releaseDate: NSDate?

    @NSManaged public
    var supportsLinux: NSNumber?

    @NSManaged public
    var supportsMac: NSNumber?

    @NSManaged public
    var supportsWindows: NSNumber?

    @NSManaged public
    var type: String?

    @NSManaged public
    var website: String?

    // MARK: - Relationships

    @NSManaged public
    var app: App?

}

