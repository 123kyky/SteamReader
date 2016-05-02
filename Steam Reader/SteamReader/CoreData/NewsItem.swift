import Foundation
import SwiftyJSON

@objc(NewsItem)
public class NewsItem: _NewsItem, JSONImportNSManagedObjectProtocol {
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
        let newsItem: NewsItem? = CoreDataInterface.singleton.newsItemForId(dictionary["gid"] as! String)
        if newsItem == nil {
            return .NewObject
        }
        
        if newsItem != nil &&
            newsItem?.app?.appId == app!.appId &&
            newsItem?.gid == dictionary["gid"] as? String &&
            newsItem?.title == dictionary["title"] as? String &&
            newsItem?.author == dictionary["author"] as? String &&
            newsItem?.contents == dictionary["contents"] as? String &&
            newsItem?.url == dictionary["url"] as? String &&
            newsItem?.isExternalURL == dictionary["isExternalURL"] as? Bool &&
            newsItem?.feedLabel == dictionary["feedLabel"] as? String &&
            newsItem?.feedName == dictionary["feedName"] as? String &&
            newsItem?.date?.compare((dictionary["date"] as? NSDate)!) == .OrderedSame {
            return .Matches
        } else {
            return .Updated
        }
    }
}
