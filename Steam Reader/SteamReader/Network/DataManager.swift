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
    
    func importApps(json: JSON) {
        // Build dictionary for import
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
        
        // TODO: Test this
//        appsToImport.append(appsRaw.first!)
//        appsToUpdate.append(appsRaw.last!)
        
        // Import
        if appsToImport.count > 0 {
            App.MR_importFromArray(appsToImport, inContext: CoreDataInterface.singleton.context)
            CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
        }
        
        // Update
        if appsToUpdate.count > 0 {
            let apps = App.MR_importFromArray(appsToUpdate, inContext: CoreDataInterface.singleton.context) as? [App] ?? []
            let ids = (appsToUpdate as NSArray).valueForKeyPath("appId") as! NSArray
            let predicate = NSPredicate(format: "appId IN %@", ids)
            App.MR_deleteAllMatchingPredicate(predicate, inContext: CoreDataInterface.singleton.context)
            for app in apps {
                if let appDetails = CoreDataInterface.singleton.appDetailsForAppId(app.appId!) {
                    app.details = appDetails
                }
                
                if app.appId != nil {
                    let newsItems = CoreDataInterface.singleton.newsItemsForAppId(app.appId!) ?? []
                    if newsItems.count > 0 {
                        app.newsItems = NSSet(array: newsItems)
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
    }
    
    func importFeatured(json: JSON) {
        // Build dictionary for import
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
            } else if name == "Top Sellers" {
                newReleasesRaw = subJSON["items"]
            } else if name == "New Releases" {
                topSellersRaw = subJSON["items"]
            }
        }
        
        setAppFeaturedValues(specialsRaw , key: "special")
        setAppFeaturedValues(comingSoonRaw, key: "comingSoon")
        setAppFeaturedValues(newReleasesRaw, key: "newRelease")
        setAppFeaturedValues(topSellersRaw, key: "topSeller")
    }
    
    private func setAppFeaturedValues(json: JSON?, key: String) {
        if json == nil { return }
        
        var ids: [String : NSNumber] = [:]
        for (_, subJSON):(String, JSON) in json! {
            ids[subJSON["id"].stringValue] = subJSON["type"].numberValue
        }
        
        for app in CoreDataInterface.singleton.appsForIds(Array(ids.keys)) {
            app.setValue(true, forKey: key)
            app.type = ids[app.appId!]
        }
        
        for app in CoreDataInterface.singleton.appsNotInIds(Array(ids.keys)) {
            app.setValue(false, forKey: key)
        }
        
        CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
    }
    
    func importAppsDetails(json: JSON) {
        // Build dictionary for import
        var appsRaw: [[NSObject : AnyObject]] = []
        for (_, subJSON):(String, JSON) in json {
            let app = CoreDataInterface.singleton.appForId(subJSON.arrayObject!.first as! String)
            appsRaw.append(AppDetails.importDictionaryFromJSON(subJSON, app: app))
            app?.type = subJSON["type"].numberValue
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
            AppDetails.MR_importFromArray(appsToImport, inContext: CoreDataInterface.singleton.context)
            CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
        }
        
        // Update
        if appsToUpdate.count > 0 {
            let appsDetails = AppDetails.MR_importFromArray(appsToUpdate, inContext: CoreDataInterface.singleton.context) as? [AppDetails] ?? []
            let ids = (appsToUpdate as NSArray).valueForKeyPath("appId") as! NSArray
            let predicate = NSPredicate(format: "appId IN %@", ids)
            AppDetails.MR_deleteAllMatchingPredicate(predicate, inContext: CoreDataInterface.singleton.context)
            for appDetails in appsDetails {
                let app = CoreDataInterface.singleton.appForId(appDetails.appId!)
                appDetails.app = app
            }
            CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
        }
        
        print("Imported \(appsToImport.count) app details items into the database.")
        print("Overwrote \(appsToUpdate.count) app details in the database.")
    }
    
    func importNewsItems(json: JSON, app: App) {
        // Build dictionary for import
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
            NewsItem.MR_importFromArray(newsToImport, inContext: CoreDataInterface.singleton.context)
            CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
        }
        
        // Update
        if newsToUpdate.count > 0 {
            let newsItems = NewsItem.MR_importFromArray(newsToUpdate, inContext: CoreDataInterface.singleton.context) as? [NewsItem] ?? []
            let ids = (newsToUpdate as NSArray).valueForKeyPath("gId") as! NSArray
            let predicate = NSPredicate(format: "gId IN %@", ids)
            NewsItem.MR_deleteAllMatchingPredicate(predicate, inContext: CoreDataInterface.singleton.context)
            for newsItem in newsItems {
                newsItem.app = app
            }
            CoreDataInterface.singleton.context.MR_saveToPersistentStoreAndWait()
        }
        
        print("Imported \(newsToImport.count) news items into the database.")
        print("Overwrote \(newsToUpdate.count) news items in the database.")
    }
}
