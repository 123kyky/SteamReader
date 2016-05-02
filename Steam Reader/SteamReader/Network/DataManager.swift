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
    
    // TODO: Prune news items older than 10 days
    
    // MARK: - Importing
    
    func importApps(json: JSON) {
        // Build dictionary for import
        var appsRaw: [[NSObject : AnyObject]] = []
        for (_, subJson):(String, JSON) in json["applist", "apps"] {
            appsRaw.append(App.importDictionaryFromJSON(subJson, app: nil))
        }
        
        // Handle items that are already cached
        var i = 0
        var appsToImport: [[NSObject : AnyObject]] = appsRaw
        var appsToUpdate: [[NSObject : AnyObject]] = []
        for dictionary in appsRaw {
            switch App.importDictionaryMatches(dictionary, app: nil) {
            case .Matches:
                appsToImport.removeAtIndex(i)
            case .Updated:
                appsToUpdate.append(dictionary)
                appsToImport.removeAtIndex(i)
            case .NewObject:
                i += 1
            }
        }
        
        // Import
        App.MR_importFromArray(appsToImport, inContext: NSManagedObjectContext.MR_defaultContext())
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            
        // Update
        let apps = App.MR_importFromArray(appsToUpdate, inContext: NSManagedObjectContext.MR_defaultContext()) as? [App] ?? []
        let ids = (appsToUpdate as NSArray).valueForKeyPath("appId") as! NSArray
        let predicate = NSPredicate(format: "NOT (appId IN %@)", ids)
        App.MR_deleteAllMatchingPredicate(predicate, inContext: NSManagedObjectContext.MR_defaultContext())
        for app in apps {
            app.details = CoreDataInterface.singleton.appDetailsForAppId(app.appId!)
            app.newsItems = NSSet(array: CoreDataInterface.singleton.newsItemsForAppId(app.appId!))
        }
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        // Remove
        var removedCount = 0
        if App.MR_countOfEntities() != UInt(appsRaw.count) {
            let allIds = (appsRaw as NSArray).valueForKeyPath("appId") as! NSArray
            for app in CoreDataInterface.singleton.allApps() {
                if !allIds.containsObject(app.appId!) {
                    if app.details != nil {
                        app.details!.MR_deleteEntity()
                    }
                    
                    app.MR_deleteEntity()
                    
                    removedCount += 1
                }
            }
        }
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        print("Imported \(appsToImport.count) apps into the database.")
        print("Overwrote \(appsToUpdate.count) apps in the database.")
        print("Deleted \(removedCount) apps in the database.")
    }
    
    func importAppDetails(json: JSON, app: App) {
        // Build dictionary for import
        var appsRaw: [[NSObject : AnyObject]] = []
        for (_, subJson):(String, JSON) in json["appnews", "newsitems"] {
            appsRaw.append(AppDetails.importDictionaryFromJSON(subJson, app: nil))
        }
        
        // Handle items that are already cached
        var i = 0
        var appsToImport: [[NSObject : AnyObject]] = appsRaw
        var appsToUpdate: [[NSObject : AnyObject]] = []
        for dictionary in appsRaw {
            switch AppDetails.importDictionaryMatches(dictionary, app: app) {
            case .Matches:
                appsToImport.removeAtIndex(i)
            case .Updated:
                appsToUpdate.append(dictionary)
                appsToImport.removeAtIndex(i)
            case .NewObject:
                i += 1
            }
        }
        
        // Import
        AppDetails.MR_importFromArray(appsToImport, inContext: NSManagedObjectContext.MR_defaultContext())
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        // Update
        let appsDetails = AppDetails.MR_importFromArray(appsToUpdate, inContext: NSManagedObjectContext.MR_defaultContext()) as? [AppDetails] ?? []
        let ids = (appsToUpdate as NSArray).valueForKeyPath("appid") as! NSArray // TODO: Update me
        let predicate = NSPredicate(format: "NOT (appId IN %@)", ids) // TODO: Update me
        AppDetails.MR_deleteAllMatchingPredicate(predicate, inContext: NSManagedObjectContext.MR_defaultContext())
        for appDetails in appsDetails {
            appDetails.app = app
        }
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        print("Imported \(appsToImport.count) news items into the database.")
        print("Overwrote \(appsToUpdate.count) apps in the database.")
    }
    
    func importNewsItems(json: JSON, app: App) {
        // Build dictionary for import
        var newsRaw: [[NSObject : AnyObject]] = []
        for (_, subJson):(String, JSON) in json["appnews", "newsitems"] {
            newsRaw.append(NewsItem.importDictionaryFromJSON(subJson, app: nil))
        }
        
        // Handle items that are already cached
        var i = 0
        var newsToImport: [[NSObject : AnyObject]] = newsRaw
        var newsToUpdate: [[NSObject : AnyObject]] = []
        for dictionary in newsRaw {
            switch NewsItem.importDictionaryMatches(dictionary, app: app) {
            case .Matches:
                newsToImport.removeAtIndex(i)
            case .Updated:
                newsToUpdate.append(dictionary)
                newsToImport.removeAtIndex(i)
            case .NewObject:
                i += 1
            }
        }
        
        // Import
        NewsItem.MR_importFromArray(newsToImport, inContext: NSManagedObjectContext.MR_defaultContext())
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        // Update
        let newsItems = NewsItem.MR_importFromArray(newsToUpdate, inContext: NSManagedObjectContext.MR_defaultContext()) as? [NewsItem] ?? []
        let ids = (newsToUpdate as NSArray).valueForKeyPath("gid") as! NSArray
        let predicate = NSPredicate(format: "NOT (gid IN %@)", ids)
        NewsItem.MR_deleteAllMatchingPredicate(predicate, inContext: NSManagedObjectContext.MR_defaultContext())
        for newsItem in newsItems {
            newsItem.app = app
        }
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        print("Imported \(newsToImport.count) news items into the database.")
        print("Overwrote \(newsToUpdate.count) apps in the database.")
    }
}
