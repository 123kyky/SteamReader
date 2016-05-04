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
    
    func featured(success: (JSON) -> Void, failure: (NSError?) -> Void) {
        let request = Alamofire.request(.GET, "http://store.steampowered.com/api/featuredcategories/", parameters: ["trailer" : false])
        if !isRequestActive(request) {
            request.responseJSON { response in
                self.defaultResponse(response, success, failure)
                self.requestCompleted(request)
            }
        }
    }
    
    func allApps(success: (JSON) -> Void, failure: (NSError?) -> Void) {
        let request = Alamofire.request(.GET, "https://api.steampowered.com/ISteamApps/GetAppList/v0002/", parameters: ["key" : key])
        if !isRequestActive(request) {
            request.responseJSON { response in
                self.defaultResponse(response, success, failure)
                self.requestCompleted(request)
            }
        }
    }
    
    private var jsons: [JSON] = []
    func appsDetailsForApps(apps: [App], success: (JSON) -> Void, failure: (NSError?) -> Void) {
        if apps.count == 0 { return }
        
        appDetailsForApp(apps.first!, success: { (json) in
            self.jsons.append(json)
            if apps.count == 1 {
                success(JSON(self.jsons))
                self.jsons = []
            } else {
                var remainingApps = apps
                remainingApps.removeFirst()
                self.appsDetailsForApps(remainingApps, success: success, failure: failure)
            }
        }, failure: { (error) in
            failure(error)
        })
    }
    
    func appDetailsForApp(app: App, success: (JSON) -> Void, failure: (NSError?) -> Void) {
        let request = Alamofire.request(.GET, "http://store.steampowered.com/api/appdetails/", parameters: ["appids" : app.appId!])
        if !isRequestActive(request) {
            request.responseJSON { response in
                self.defaultResponse(response, success, failure)
                self.requestCompleted(request)
            }
        }
    }
    
    func newsItemsForApp(app: App, success: (JSON) -> Void, failure: (NSError?) -> Void) {
        let request = Alamofire.request(.GET, "http://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/", parameters: ["appid" : app.appId!, "count" : 10, "key" : key])
        if !isRequestActive(request) {
            request.responseJSON { response in
                self.defaultResponse(response, success, failure)
                self.requestCompleted(request)
            }
        }
    }
    
    // MARK: - Request Management
    // TODO: Work with delegate
    
    var activeRequests: [String] = []
    func isRequestActive(request: Request) -> Bool {
        let requestString = request.request?.URLString ?? ""
        if activeRequests.contains(requestString) {
            return true
        } else {
            activeRequests.append(requestString)
            return false
        }
    }
    
    func requestCompleted(request: Request) {
        let requestString = request.request?.URLString ?? ""
        if let index = activeRequests.indexOf(requestString) {
            activeRequests.removeAtIndex(index)
        }
    }

}
