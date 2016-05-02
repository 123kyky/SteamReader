import Foundation
import SwiftyJSON

@objc(App)
public class App: _App, JSONImportNSManagedObjectProtocol {
    class func importDictionaryFromJSON(json: JSON) -> [NSObject: AnyObject] {
        return [
            "appId" : json["appid"].stringValue,
            "name" : json["name"].stringValue
        ]
    }
}
