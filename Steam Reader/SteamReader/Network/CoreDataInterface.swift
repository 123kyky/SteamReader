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
    
    // MARK: - NewsItems
    
    func newsItemsForApp(app: App) -> [NewsItem] {
        return NewsItem.MR_findByAttribute("app", withValue: app) as? [NewsItem] ?? []
    }
}
