//
//  AppDelegate.swift
//  Steam Reader
//
//  Created by Kyle Roberts on 4/26/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setUpData()
        
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        MagicalRecord.cleanUp()
    }
    
    // MARK: - Data
    
    func setUpData() {
        setUpCoreData()
        fetchSteamApps()
    }
    
    func setUpCoreData() {
        MagicalRecord.setupCoreDataStack()
        MagicalRecord.setLoggingLevel(.Off)
    }
    
    func fetchSteamApps() {
        NetworkManager.singleton.fetchAllApps()
        DataManager.singleton.pruneNewsItems()
    }

}

