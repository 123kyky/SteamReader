//
//  CoreDataInterface.swift
//  SteamReader
//
//  Created by Kyle Roberts on 5/2/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import Foundation
import CoreData

class CoreDataInterface: NSObject {
    static let singleton = CoreDataInterface()
    
    var context = NSManagedObjectContext.MR_defaultContext()
    
    // MARK: - Apps
    
    func allApps() -> [App] {
        return App.MR_findAllInContext(CoreDataInterface.singleton.context) as? [App] ?? []
    }
    
    func appsForIds(ids: [String]) -> [App] {
        return App.MR_findAllWithPredicate(NSPredicate(format: "SELF.appId in %@", ids)) as? [App] ?? []
    }
    
    func appsNotInIds(ids: [String]) -> [App] {
        return App.MR_findAllWithPredicate(NSPredicate(format: "NOT (SELF.appId in %@)", ids)) as? [App] ?? []
    }
    
    func appForId(id: String) -> App? {
        return (App.MR_findByAttribute("appId", withValue: id, inContext: CoreDataInterface.singleton.context) as? [App] ?? []).first
    }
    
    // MARK: - AppDetails
    
    func allAppDetails() -> [AppDetails] {
        return AppDetails.MR_findAllInContext(CoreDataInterface.singleton.context) as? [AppDetails] ?? []
    }
    
    func appDetailsForApp(app: App) -> AppDetails? {
        return (AppDetails.MR_findByAttribute("app", withValue: app, inContext: CoreDataInterface.singleton.context) as? [AppDetails] ?? []).first
    }
    
    func appDetailsForAppId(appId: String) -> AppDetails? {
        return (AppDetails.MR_findByAttribute("appId", withValue: appId, inContext: CoreDataInterface.singleton.context) as? [AppDetails] ?? []).first
    }
    
    // MARK: - NewsItems
    
    func allNewsItems() -> [NewsItem] {
        return NewsItem.MR_findAllInContext(CoreDataInterface.singleton.context) as? [NewsItem] ?? []
    }
    
    func newsItemsForApp(app: App) -> [NewsItem] {
        return NewsItem.MR_findByAttribute("app", withValue: app, inContext: CoreDataInterface.singleton.context) as? [NewsItem] ?? []
    }
    
    func newsItemsForAppId(appId: String) -> [NewsItem] {
        return NewsItem.MR_findByAttribute("appId", withValue: appId, inContext: CoreDataInterface.singleton.context) as? [NewsItem] ?? []
    }
    
    func newsItemForId(gId: String) -> NewsItem? {
        return (NewsItem.MR_findByAttribute("gId", withValue: gId, inContext: CoreDataInterface.singleton.context) as? [NewsItem] ?? []).first
    }
}
