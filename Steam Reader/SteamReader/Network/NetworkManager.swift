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
    
    func fetchDetailsForApp(app: App) {
        NetworkInterface.singleton.appDetailsForApp(app, success: { (json) in
            DataManager.singleton.importAppDetails(json, app: app)
        }) { (error) in
            NSLog("Error fetching all apps: \(error)")
        }
    }
    
    func fetchNewsForApp(app: App) {
        NetworkInterface.singleton.newsItemsForApp(app, success: { (json) in
            DataManager.singleton.importNewsItems(json, app: app)
        }) { (error) in
            NSLog("Error fetching all apps: \(error)")
        }
    }
}
