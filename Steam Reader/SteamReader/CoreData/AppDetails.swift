import Foundation
import SwiftyJSON

@objc(AppDetails)
public class AppDetails: _AppDetails, JSONImportNSManagedObjectProtocol {
    class func importDictionaryFromJSON(json: JSON) -> [NSObject: AnyObject] {
        return [
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
}
