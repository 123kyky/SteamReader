//
//  NetworkInterface.swift
//  SteamReader
//
//  Created by Kyle Roberts on 5/2/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import Alamofire
import SwiftyJSON
import Async

class NetworkInterface: NSObject {
    static let singleton = NetworkInterface()
    
    var key: String {
        get {
            do {
                let path = NSBundle.mainBundle().pathForResource("SteamKey", ofType: "")
                return try NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding) as String
            } catch {
                print("Error getting key from SteamKey file.")
                return ""
            }
        }
    }
    
    let defaultResponse = { (response: Response<AnyObject, NSError>, success: (JSON) -> Void, failure: (NSError?) -> Void) -> Void in
        Async.background {
            switch response.result {
            case .Success(let value):
                success(JSON(value))
            case .Failure(let error):
                failure(error)
            }
        }
    }
    
    func allApps(success: (JSON) -> Void, failure: (NSError?) -> Void) {
        Alamofire.request(.GET, "https://api.steampowered.com/ISteamApps/GetAppList/v0002/", parameters: ["key" : key])
            .responseJSON { response in
                self.defaultResponse(response, success, failure)
        }
    }
    
    var jsons: [JSON] = []
    func appDetailsForApps(apps: [App], success: (JSON) -> Void, failure: (NSError?) -> Void) {
        appDetailsForApp(apps.first!, success: { (json) in
            self.jsons.append(json)
            if apps.count == 1 {
                var combinedJSON: JSON = self.jsons.first!
                self.jsons.removeFirst()
                for json in self.jsons {
                    combinedJSON = JSON(combinedJSON.arrayObject! + json.arrayObject!)
                }
                success(combinedJSON)
                self.jsons = []
            } else {
                var remainingApps = apps
                remainingApps.removeAtIndex(0)
                self.appDetailsForApps(remainingApps, success: success, failure: failure)
            }
        }, failure: { (error) in
            failure(error)
        })
    }
    
    private func appDetailsForApp(app: App, success: (JSON) -> Void, failure: (NSError?) -> Void) {
        Alamofire.request(.GET, "http://store.steampowered.com/api/appdetails/", parameters: ["appids" : app.appId!, "filters" : ["type" : "game"]])
            .responseJSON { response in
                self.defaultResponse(response, success, failure)
        }
    }
    
    func newsItemsForApp(app: App, success: (JSON) -> Void, failure: (NSError?) -> Void) {
        Alamofire.request(.GET, "http://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/", parameters: ["appid" : app.appId!, "count" : 10, "key" : key])
            .responseJSON { response in
                self.defaultResponse(response, success, failure)
        }
    }

}
