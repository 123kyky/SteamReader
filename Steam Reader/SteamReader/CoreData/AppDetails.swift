import Foundation
import SwiftyJSON

@objc(AppDetails)
public class AppDetails: _AppDetails, JSONImportNSManagedObjectProtocol {
    // TODO: Update for AppDetails
    class func importDictionaryFromJSON(json: JSON, app: App?) -> [NSObject: AnyObject] {
        return [
            "appId" : app!.appId!,
            "gid" : json["gid"].stringValue,
            "title" : json["title"].stringValue,
            "author" : json["author"].stringValue,
            "contents" : json["contents"].stringValue,
            "url" : json["url"].stringValue,
            "isExternalURL" : json["is_external_url"].boolValue,
            "feedLabel" : json["feedLabel"].stringValue,
            "feedName" : json["feedName"].stringValue,
            "date" : NSDate(timeIntervalSince1970: json["date"].doubleValue)
        ]
    }
    
    class func importDictionaryMatches(dictionary: [NSObject : AnyObject], app: App?) -> ImportDictionaryMatchingState {
        let appDetails: AppDetails? = CoreDataInterface.singleton.appDetailsForApp(app!)
        if appDetails == nil {
            return .NewObject
        }
        
        if appDetails != nil &&
            appDetails?.app?.appId == app!.appId &&
            appDetails?.about == dictionary["about"] as? String {
            return .Matches
        } else {
            return .Updated
        }
    }
}
