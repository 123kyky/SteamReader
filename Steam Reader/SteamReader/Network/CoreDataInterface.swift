//
//  CoreDataInterface.swift
//  SteamReader
//
//  Created by Kyle Roberts on 5/2/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import Foundation

class CoreDataInterface: NSObject {
    static let singleton = CoreDataInterface()
    
    // MARK: - Apps
    
    func allApps() -> [App] {
        return App.MR_findAll() as? [App] ?? []
    }
    
    func appForId(id: String) -> App? {
        return (App.MR_findByAttribute("appId", withValue: id) as? [App] ?? []).first
    }
    
    // MARK: - AppDetails
    
    func appDetailsForApp(app: App) -> AppDetails? {
        return (AppDetails.MR_findByAttribute("app", withValue: app) as? [AppDetails] ?? []).first
    }
    
    func appDetailsForAppId(appId: String) -> AppDetails? {
        return (AppDetails.MR_findByAttribute("appId", withValue: appId) as? [AppDetails] ?? []).first
    }
    
    // MARK: - NewsItems
    
    func newsItemsForApp(app: App) -> [NewsItem] {
        return NewsItem.MR_findByAttribute("app", withValue: app) as? [NewsItem] ?? []
    }
    
    func newsItemsForAppId(appId: String) -> [NewsItem] {
        return NewsItem.MR_findByAttribute("appId", withValue: appId) as? [NewsItem] ?? []
    }
    
    func newsItemForId(gid: String) -> NewsItem? {
        return (NewsItem.MR_findByAttribute("gid", withValue: gid) as? [NewsItem] ?? []).first
    }
}
