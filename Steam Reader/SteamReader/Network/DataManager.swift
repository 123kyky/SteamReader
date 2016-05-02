//
//  DataManager.swift
//  SteamReader
//
//  Created by Kyle Roberts on 4/27/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import CoreData
import SwiftyJSON

class DataManager: NSObject {
    static let singleton = DataManager()
    
    // MARK: - Pruning 
    
    // TODO: Prune news items older than 10 days, removed apps/details
    
    // MARK: - Importing
    
    func importApps(json: JSON) {
        var appsRaw: [[NSObject : AnyObject]] = []
        for (_, subJson):(String, JSON) in json["applist", "apps"] {
            appsRaw.append(App.importDictionaryFromJSON(subJson))
        }
        
        App.MR_importFromArray(appsRaw, inContext: NSManagedObjectContext.MR_defaultContext())
        let ids = (appsRaw as NSArray).valueForKeyPath("appId") as! NSArray
        let predicate = NSPredicate(format: "NOT (appId IN %@)", ids)
        App.MR_deleteAllMatchingPredicate(predicate, inContext: NSManagedObjectContext.MR_defaultContext())
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        print("Imported \(ids.count) apps into the database.")
    }
    
    func importAppDetails(json: JSON, app: App) {
        var appsRaw: [[NSObject : AnyObject]] = []
        for (_, subJson):(String, JSON) in json["appnews", "newsitems"] {
            appsRaw.append(AppDetails.importDictionaryFromJSON(subJson))
        }
        
        let appsDetails = AppDetails.MR_importFromArray(appsRaw, inContext: NSManagedObjectContext.MR_defaultContext()) as? [AppDetails] ?? []
        let ids = (appsRaw as NSArray).valueForKeyPath("gid") as! NSArray // TODO: Update me
        let predicate = NSPredicate(format: "NOT (gid IN %@)", ids) // TODO: Update me
        AppDetails.MR_deleteAllMatchingPredicate(predicate, inContext: NSManagedObjectContext.MR_defaultContext())
        for appDetails in appsDetails {
            appDetails.app = app
        }
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        print("Imported \(ids.count) news items into the database.")
    }
    
    func importNewsItems(json: JSON, app: App) {
        var newsRaw: [[NSObject : AnyObject]] = []
        for (_, subJson):(String, JSON) in json["appnews", "newsitems"] {
            newsRaw.append(NewsItem.importDictionaryFromJSON(subJson))
        }
        
        let newsItems = NewsItem.MR_importFromArray(newsRaw, inContext: NSManagedObjectContext.MR_defaultContext()) as? [NewsItem] ?? []
        let ids = (newsRaw as NSArray).valueForKeyPath("gid") as! NSArray
        let predicate = NSPredicate(format: "NOT (gid IN %@)", ids)
        NewsItem.MR_deleteAllMatchingPredicate(predicate, inContext: NSManagedObjectContext.MR_defaultContext())
        for newsItem in newsItems {
            newsItem.app = app
        }
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        print("Imported \(ids.count) news items into the database.")
    }
}
