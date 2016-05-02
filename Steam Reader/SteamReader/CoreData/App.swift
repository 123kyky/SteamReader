import Foundation
import SwiftyJSON

@objc(App)
public class App: _App, JSONImportNSManagedObjectProtocol {
    class func importDictionaryFromJSON(json: JSON, app: App?) -> [NSObject: AnyObject] {
        return [
            "appId" : json["appid"].stringValue,
            "name" : json["name"].stringValue,
        ]
    }
    
    class func importDictionaryMatches(dictionary: [NSObject : AnyObject], app: App?) -> ImportDictionaryMatchingState {
        let existingApp: App? = CoreDataInterface.singleton.appForId(dictionary["appId"] as! String)
        if existingApp == nil {
            return .NewObject
        }
        
        if existingApp?.appId == dictionary["appId"] as? String &&
            existingApp?.name == dictionary["name"] as? String {
            return .Matches
        } else {
            return .Updated
        }
    }
}
