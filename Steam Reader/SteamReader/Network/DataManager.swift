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
}
