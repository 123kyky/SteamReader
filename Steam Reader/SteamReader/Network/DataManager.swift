//
//  DataManager.swift
//  SteamReader
//
//  Created by Kyle Roberts on 4/27/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class DataManager: NSObject {
    static let singleton = DataManager()
    
    // MARK: - Data Management
    
    func overwriteApps(json: JSON) {
        var appsRaw: [[NSObject : AnyObject]] = []
        for (_, subJson):(String, JSON) in json["applist", "apps"] {
            appsRaw.append(["appId" : subJson["appid"].stringValue, "name" : subJson["name"].stringValue])
        }
        
        App.MR_importFromArray(appsRaw, inContext: NSManagedObjectContext.MR_defaultContext())
        let ids = (appsRaw as NSArray).valueForKeyPath("appId") as! NSArray
        let predicate = NSPredicate(format: "NOT (appId IN %@)", ids)
        App.MR_deleteAllMatchingPredicate(predicate, inContext: NSManagedObjectContext.MR_defaultContext())
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        print("Overwrote \(ids.count) apps in the database.")
    }
    
    func overwriteNewsItems(json: JSON, app: App) {
        var newsRaw: [[NSObject : AnyObject]] = []
        for (_, subJson):(String, JSON) in json["appnews", "newsitems"] {
            newsRaw.append(["gid" : subJson["gid"].stringValue,
                "title" : subJson["title"].stringValue,
                "author" : subJson["author"].stringValue,
                "contents" : subJson["contents"].stringValue,
                "url" : subJson["url"].stringValue,
                "isExternalURL" : subJson["is_external_url"].boolValue,
                "feedLabel" : subJson["feedLabel"].stringValue,
                "feedName" : subJson["feedName"].stringValue,
                "date" : NSDate(timeIntervalSince1970: subJson["date"].doubleValue)])
        }
        
        let newsItems = NewsItem.MR_importFromArray(newsRaw, inContext: NSManagedObjectContext.MR_defaultContext()) as? [NewsItem] ?? []
        let ids = (newsRaw as NSArray).valueForKeyPath("gid") as! NSArray
        let predicate = NSPredicate(format: "NOT (gid IN %@)", ids)
        NewsItem.MR_deleteAllMatchingPredicate(predicate, inContext: NSManagedObjectContext.MR_defaultContext())
        for newsItem in newsItems {
            newsItem.app = app
        }
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        print("Overwrote \(ids.count) news items in the database.")
    }
    
    // MARK: - Apps
    
    func allApps() -> [App] {
        return App.MR_findAll() as? [App] ?? []
    }
    
    // MARK: - NewsItems
    
    func newsItemsForApp(app: App) -> [NewsItem] {
        return NewsItem.MR_findByAttribute("app", withValue: app) as? [NewsItem] ?? []
    }
}
