//
//  DataManager.swift
//  SteamReader
//
//  Created by Kyle Roberts on 4/27/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import CoreData
import SwiftyJSON
import Async

class DataManager: NSObject {
    static let singleton = DataManager()
    
    // MARK: - Pruning
    
    // TODO: Consider pruning unsubscribed news
    func pruneNewsItems() {
        var removedCount = 0
        for newsItem in CoreDataInterface.singleton.allNewsItems() {
            let days = NSCalendar.currentCalendar().components(.Day, fromDate: newsItem.date!, toDate: NSDate(), options: []).day
            if days > 30 {
                removedCount += 1
                newsItem.MR_deleteEntityInContext(CoreDataInterface.singleton.context)
            }
        }
        CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
        
        print("Deleted \(removedCount) news items in the database.")
    }
    
    // MARK: - Importing
    
    static let AppListUpdatedNotificationName = "AppListUpdatedNotificationName"
    static let FeaturedAppsUpdatedNotificationName = "FeaturedAppsUpdatedNotificationName"
    
    func importApps(json: JSON) {
        // Build dictionaries for import
        var appsRaw: [[NSObject : AnyObject]] = []
        for (_, subJSON):(String, JSON) in json["applist", "apps"] {
            appsRaw.append(App.importDictionaryFromJSON(subJSON, app: nil))
        }
        
        // Handle items that are already cached
        var i = 0
        var appsToImport: [[NSObject : AnyObject]] = appsRaw
        var appsToUpdate: [[NSObject : AnyObject]] = []
        for dictionary in appsRaw {
            switch App.importDictionaryMatches(dictionary, app: nil) {
            case .Matches, .Invalid:
                appsToImport.removeAtIndex(i)
            case .Updated:
                appsToUpdate.append(dictionary)
                appsToImport.removeAtIndex(i)
            case .NewObject:
                i += 1
            }
        }
        
        // Import
        if appsToImport.count > 0 {
            App.MR_importFromArray(appsToImport, inContext: CoreDataInterface.singleton.context)
            CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
        }
        
        // Update
        if appsToUpdate.count > 0 {
            let ids = (appsToUpdate as NSArray).valueForKeyPath("appId") as! NSArray
            let predicate = NSPredicate(format: "appId IN %@", ids)
            let apps = App.MR_findAllWithPredicate(predicate) as? [App] ?? []
            for app in apps {
                for dictionary in appsToUpdate {
                    if (dictionary["appId"] as! String) == app.appId! {
                        updateObjectWithDictionary(app, dictionary: dictionary)
                    }
                }
            }
            CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
        }
        
        // Remove
        var removedCount = 0
        if App.MR_countOfEntitiesWithContext(CoreDataInterface.singleton.context) != UInt(appsRaw.count) {
            let allIds = (appsRaw as NSArray).valueForKeyPath("appId") as! NSArray
            for app in CoreDataInterface.singleton.allApps() {
                if !allIds.containsObject(app.appId!) {
                    if app.details != nil {
                        app.details!.MR_deleteEntityInContext(CoreDataInterface.singleton.context)
                    }
                    
                    removedCount += 1
                    app.MR_deleteEntityInContext(CoreDataInterface.singleton.context)
                }
            }
        }
        CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
        
        print("Imported \(appsToImport.count) apps into the database.")
        print("Overwrote \(appsToUpdate.count) apps in the database.")
        print("Deleted \(removedCount) apps in the database.")
        
        Async.main {
            NSNotificationCenter.defaultCenter().postNotificationName(DataManager.AppListUpdatedNotificationName, object: nil)
        }
    }
    
    func importFeatured(json: JSON) {
        // Build dictionaries for import
        var specialsRaw: JSON?
        var comingSoonRaw: JSON?
        var newReleasesRaw: JSON?
        var topSellersRaw: JSON?
        for (_, subJSON):(String, JSON) in json {
            let name = subJSON["name"].stringValue
            if name == "Specials" {
                specialsRaw = subJSON["items"]
            } else if name == "Coming Soon" {
                comingSoonRaw = subJSON["items"]
            } else if name == "New Releases" {
                newReleasesRaw = subJSON["items"]
            } else if name == "Top Sellers" {
                topSellersRaw = subJSON["items"]
            }
        }
        
        var counts: [(Int, Int, Int)] = []
        counts.append(setAppFeaturedValues(specialsRaw , key: "special"))
        counts.append(setAppFeaturedValues(comingSoonRaw, key: "comingSoon"))
        counts.append(setAppFeaturedValues(newReleasesRaw, key: "newRelease"))
        counts.append(setAppFeaturedValues(topSellersRaw, key: "topSeller"))
        
        // Counting for logs
        var imported = 0
        var featured = 0
        var unfeatured = 0
        for count: (imported: Int, featured: Int, unfeatured: Int) in counts {
            imported += count.imported
            featured += count.featured
            unfeatured += count.unfeatured
        }
        
        print("Imported \(imported) featured apps into the database.")
        print("Featured \(featured) existing apps in the database.")
        print("Unfeatured \(unfeatured) existing apps in the database.")
        
        Async.main {
            NSNotificationCenter.defaultCenter().postNotificationName(DataManager.FeaturedAppsUpdatedNotificationName, object: nil)
        }
    }
    
    private func setAppFeaturedValues(json: JSON?, key: String) -> (Int, Int, Int) {
        if json == nil { return (0, 0, 0) }
        
        // Build dictionaries for import and handle items that are already cached
        var featured = 0
        var ids: [String] = []
        var appsToImport: [[NSObject : AnyObject]] = []
        for (_, subJSON):(String, JSON) in json! {
            ids.append(subJSON["id"].stringValue)
            if let app = CoreDataInterface.singleton.appForId(ids.last!) {
                featured += 1
                app.setValue(true, forKey: key)
                app.type = subJSON["type"].numberValue
            } else {
                var importJSON = subJSON
                importJSON["appid"] = JSON(ids.last!)
                importJSON[key] = true
                appsToImport.append(App.importDictionaryFromJSON(importJSON, app: nil))
            }
        }
        CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
        
        // Import
        if appsToImport.count > 0 {
            App.MR_importFromArray(appsToImport, inContext: CoreDataInterface.singleton.context)
            CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
        }
        
        // "Removing"
        var unfeatured = 0
        for app in CoreDataInterface.singleton.appsNotInIds(ids) {
            if app.valueForKey(key) as? Bool == true {
                unfeatured += 1
                app.setValue(false, forKey: key)
            }
        }
        CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
        
        return (appsToImport.count, featured, unfeatured)
    }
    
    func importAppDetails(json: JSON, app: App) -> (imported: Int, overwritten: Int) {
        // Build dictionaries for import
        var appsRaw: [[NSObject : AnyObject]] = []
        for (_, subJSON):(String, JSON) in json {
            appsRaw.append(AppDetails.importDictionaryFromJSON(subJSON["data"], app: app))
            app.type = subJSON["data", "type"].numberValue
        }
        CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
        
        // Handle items that are already cached
        var i = 0
        var appsToImport: [[NSObject : AnyObject]] = appsRaw
        var appsToUpdate: [[NSObject : AnyObject]] = []
        for dictionary in appsRaw {
            let app = CoreDataInterface.singleton.appForId(dictionary["appId"] as! String)
            switch AppDetails.importDictionaryMatches(dictionary, app: app) {
            case .Matches, .Invalid:
                appsToImport.removeAtIndex(i)
            case .Updated:
                appsToUpdate.append(dictionary)
                appsToImport.removeAtIndex(i)
            case .NewObject:
                i += 1
            }
        }
        
        // Import
        if appsToImport.count > 0 {
            let appsDetails = AppDetails.MR_importFromArray(appsToImport, inContext: CoreDataInterface.singleton.context) as? [AppDetails] ?? []
            CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
            for appDetails in appsDetails {
                app.details = appDetails
            }
        }
        
        // Update
        if appsToUpdate.count > 0 {
            let ids = (appsToUpdate as NSArray).valueForKeyPath("appId") as! NSArray
            let predicate = NSPredicate(format: "appId IN %@", ids)
            let appsDetails = AppDetails.MR_findAllWithPredicate(predicate) as? [AppDetails] ?? []
            for appDetails in appsDetails {
                for dictionary in appsToUpdate {
                    if (dictionary["appId"] as! String) == app.appId! {
                        updateObjectWithDictionary(appDetails, dictionary: dictionary)
                    }
                }
            }
            CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
        }
        
        return (appsToImport.count, appsToUpdate.count)
    }
    
    func importAppsDetails(json: JSON) {
        // Build dictionaries for import
        var appsRaw: [[NSObject : AnyObject]] = []
        for (_, subJSON):(String, JSON) in json {
            let dictionary = subJSON.dictionaryValue
            let id = Array(dictionary.keys).first
            let app = CoreDataInterface.singleton.appForId(id!)
            appsRaw.append(AppDetails.importDictionaryFromJSON(subJSON[id!], app: app))
            app?.type = subJSON[id!, "data", "type"].numberValue
        }
        CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
        
        // Handle items that are already cached
        var i = 0
        var appsToImport: [[NSObject : AnyObject]] = appsRaw
        var appsToUpdate: [[NSObject : AnyObject]] = []
        for dictionary in appsRaw {
            let app = CoreDataInterface.singleton.appForId(dictionary["appId"] as! String)
            switch AppDetails.importDictionaryMatches(dictionary, app: app) {
            case .Matches, .Invalid:
                appsToImport.removeAtIndex(i)
            case .Updated:
                appsToUpdate.append(dictionary)
                appsToImport.removeAtIndex(i)
            case .NewObject:
                i += 1
            }
        }
        
        // Import
        if appsToImport.count > 0 {
            let appsDetails = AppDetails.MR_importFromArray(appsToImport, inContext: CoreDataInterface.singleton.context) as? [AppDetails] ?? []
            CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
            for appDetails in appsDetails {
                if let app = CoreDataInterface.singleton.appForId(appDetails.appId!) {
                    app.details = appDetails
                }
            }
        }
        
        // Update
        if appsToUpdate.count > 0 {
            let ids = (appsToUpdate as NSArray).valueForKeyPath("appId") as! NSArray
            let predicate = NSPredicate(format: "appId IN %@", ids)
            let appsDetails = AppDetails.MR_findAllWithPredicate(predicate) as? [AppDetails] ?? []
            for appDetails in appsDetails {
                for dictionary in appsToUpdate {
                    if (dictionary["appId"] as! String) == appDetails.app!.appId {
                        updateObjectWithDictionary(appDetails, dictionary: dictionary)
                    }
                }
            }
            CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
        }
        
        print("Imported \(appsToImport.count) app details items into the database.")
        print("Overwrote \(appsToUpdate.count) app details in the database.")
    }
    
    func importNewsItems(json: JSON, app: App) {
        // Build dictionaries for import
        var newsRaw: [[NSObject : AnyObject]] = []
        for (_, subJSON):(String, JSON) in json["appnews", "newsitems"] {
            newsRaw.append(NewsItem.importDictionaryFromJSON(subJSON, app: app))
        }
        
        // Handle items that are already cached
        var i = 0
        var newsToImport: [[NSObject : AnyObject]] = newsRaw
        var newsToUpdate: [[NSObject : AnyObject]] = []
        for dictionary in newsRaw {
            switch NewsItem.importDictionaryMatches(dictionary, app: app) {
            case .Matches, .Invalid:
                newsToImport.removeAtIndex(i)
            case .Updated:
                newsToUpdate.append(dictionary)
                newsToImport.removeAtIndex(i)
            case .NewObject:
                i += 1
            }
        }
        
        // Import
        if newsToImport.count > 0 {
            let newsItems = NewsItem.MR_importFromArray(newsToImport, inContext: CoreDataInterface.singleton.context) as? [NewsItem] ?? []
            CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
            for newsItem in newsItems {
                newsItem.app = app
            }
        }
        
        // Update
        if newsToUpdate.count > 0 {
            let ids = (newsToUpdate as NSArray).valueForKeyPath("gId") as! NSArray
            let predicate = NSPredicate(format: "gId IN %@", ids)
            let newsItems = NewsItem.MR_findAllWithPredicate(predicate) as? [NewsItem] ?? []
            for newsItem in newsItems {
                for dictionary in newsToUpdate {
                    if (dictionary["appId"] as! String) == app.appId {
                        updateObjectWithDictionary(newsItem, dictionary: dictionary)
                        newsItem.app = app
                    }
                }
            }
            CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
        }
        
        print("Imported \(newsToImport.count) news items into the database.")
        print("Overwrote \(newsToUpdate.count) news items in the database.")
    }
    
    private func updateObjectWithDictionary(object: NSManagedObject, dictionary: [NSObject : AnyObject]) {
        for key in Array(dictionary.keys) {
            object.setValue(dictionary[key], forKey: key as! String)
        }
    }
}
