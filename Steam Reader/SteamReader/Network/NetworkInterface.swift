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

class NetworkInterface: NSObject, NSURLSessionDelegate {
    static let singleton = NetworkInterface()
    let manager: Manager!
    
    override init() {
        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["Accept"] = "application/json"
        
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.steamreader.app.background")
        configuration.HTTPAdditionalHeaders = defaultHeaders
        manager = Alamofire.Manager(configuration: configuration)
        
        let reachability = NetworkReachabilityManager(host: "www.store.steampowered.com/")
        reachability?.listener = { status in
            print("Network Status Changed: \(status)")
        }
        reachability?.startListening()
        
        let delegate: Alamofire.Manager.SessionDelegate = manager.delegate
        delegate.sessionDidReceiveChallenge = { session, challenge in
            print("Session did recieve challenge")
            
            return (NSURLSessionAuthChallengeDisposition.UseCredential, nil)
        }
        
        delegate.sessionDidFinishEventsForBackgroundURLSession = { session in
            print("Session did finish events for background URL session")
        }
        
        delegate.taskWillPerformHTTPRedirection = { session, task, response, request in
            print("Task will perform HTTP redirection")
            
            return request
        }
        
        delegate.dataTaskWillCacheResponse = { session, task, response in
            print("Data task will cache response")
            
            return nil
        }
    }
    
    private var key: String {
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
                print("Request Successful: ")
                print(response.request)
                success(JSON(value))
                
            case .Failure(let error):
                print("Request Failed: ")
                debugPrint(response.request)
                
                failure(error)
            }
        }
    }
    
    func featured(success: (JSON) -> Void, failure: (NSError?) -> Void) {
        let request = manager.request(.GET, "http://store.steampowered.com/api/featuredcategories/", parameters: ["trailer" : false])
        if !isRequestActive(request) {
            print("Starting Request:")
            print(request)
            
            request.validate().responseJSON { response in
                self.defaultResponse(response, success, failure)
                self.requestCompleted(request)
            }
        }
    }
    
    func allApps(success: (JSON) -> Void, failure: (NSError?) -> Void) {
        let request = manager.request(.GET, "https://api.steampowered.com/ISteamApps/GetAppList/v0002/", parameters: ["key" : key])
        if !isRequestActive(request) {
            print("Starting Request:")
            print(request)
            
            request.validate().responseJSON { response in
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
        let request = manager.request(.GET, "http://store.steampowered.com/api/appdetails/", parameters: ["appids" : app.appId!])
        if !isRequestActive(request) {
            print("Starting Request:")
            print(request)
            
            request.validate().responseJSON { response in
                self.defaultResponse(response, success, failure)
                self.requestCompleted(request)
            }
        }
    }
    
    func newsItemsForApp(app: App, success: (JSON) -> Void, failure: (NSError?) -> Void) {
        let request = manager.request(.GET, "http://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/", parameters: ["appid" : app.appId!, "count" : 10, "key" : key])
        if !isRequestActive(request) {
            print("Starting Request:")
            print(request)
            
            request.validate().responseJSON { response in
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
