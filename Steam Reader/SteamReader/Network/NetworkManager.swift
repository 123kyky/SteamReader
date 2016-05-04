//
//  NetworkManager.swift
//  SteamReader
//
//  Created by Kyle Roberts on 5/2/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    static let singleton = NetworkManager()
    
    func fetchAllApps() {
        NetworkInterface.singleton.allApps({ (json) in
            DataManager.singleton.importApps(json)
        }) { (error) in
            NSLog("Error fetching all apps: \(error)")
        }
    }
    
    func fetchAllAppsAndFeatured() {
        NetworkInterface.singleton.allApps({ (json) in
            DataManager.singleton.importApps(json)
            self.fetchFeatured()
        }) { (error) in
            NSLog("Error fetching all apps and featured: \(error)")
        }
    }
    
    func fetchFeatured() {
        NetworkInterface.singleton.featured({ (json) in
            DataManager.singleton.importFeatured(json)
        }) { (error) in
            NSLog("Error fetching featured: \(error)")
        }
    }
    
    private var detailsCounts: [(Int, Int)] = []
    func fetchDetailsForApps(apps: [App]) {
        if apps.count == 0 { return }
        
        NetworkInterface.singleton.appDetailsForApp(apps.first!, success: { (json) in
            self.detailsCounts.append(DataManager.singleton.importAppDetails(json, app: apps.first!))
            if apps.count == 1 {
                var imported = 0
                var overwritten = 0
                for count: (imported: Int, overwritten: Int) in self.detailsCounts {
                    imported += count.imported
                    overwritten += count.overwritten
                }
                
                print("Imported \(imported) app details items into the database.")
                print("Overwrote \(overwritten) app details in the database.")
            } else {
                var remainingApps = apps
                remainingApps.removeFirst()
                self.fetchDetailsForApps(remainingApps)
            }
        }) { (error) in
            NSLog("Error fetching details for apps: \(error)")
        }
    }
    
    func bulkFetchDetailsForApps(apps: [App]) {
        NetworkInterface.singleton.appsDetailsForApps(apps, success: { (json) in
            DataManager.singleton.importAppsDetails(json)
        }) { (error) in
            NSLog("Error fetching all details for apps: \(error)")
        }
    }
    
    func fetchNewsForApp(app: App) {
        NetworkInterface.singleton.newsItemsForApp(app, success: { (json) in
            DataManager.singleton.importNewsItems(json, app: app)
        }) { (error) in
            NSLog("Error fetching news items for app: \(error)")
        }
    }
    
}
