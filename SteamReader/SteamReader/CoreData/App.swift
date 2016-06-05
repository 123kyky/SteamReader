import Foundation
import SwiftyJSON

@objc(App)
public class App: _App, JSONImportNSManagedObjectProtocol {
    
    // MARK: - JSONImportNSManagedObjectProtocol
    
    class func importDictionaryFromJSON(json: JSON, app: App?) -> [NSObject: AnyObject] {
        return [
            "appId" : json["appid"].stringValue,
            "name" : json["name"].stringValue,
            "type" : json["type"].number ?? NSNumber(int: 99),
            "special" : json["special"] != nil,
            "comingSoon" : json["comingSoon"] != nil,
            "topSeller" : json["topSeller"] != nil,
            "newRelease" : json["newRelease"] != nil,
            "subscribed" : false
        ]
    }
    
    class func importDictionaryMatches(dictionary: [NSObject : AnyObject], app: App?) -> ImportDictionaryMatchingState {
        let existingApp: App? = CoreDataInterface.singleton.appForId(dictionary["appId"] as! String)
        if existingApp == nil {
            return .NewObject
        } else if existingApp!.appId == (dictionary["appId"] as! String) &&
            existingApp!.name == (dictionary["name"] as! String) &&
            existingApp!.type == (dictionary["type"] as! NSNumber) &&
            existingApp!.special == (dictionary["special"] as! Bool) &&
            existingApp!.comingSoon == (dictionary["comingSoon"] as! Bool) &&
            existingApp!.topSeller == (dictionary["topSeller"] as! Bool) &&
            existingApp!.newRelease == (dictionary["newRelease"] as! Bool) &&
            existingApp!.subscribed == (dictionary["subscribed"] as! Bool) {
            return .Matches
        } else if dictionary["appId"] != nil &&
            dictionary["name"] != nil &&
            dictionary["special"] != nil  &&
            dictionary["comingSoon"] != nil  &&
            dictionary["topSeller"] != nil  &&
            dictionary["newRelease"] != nil  &&
            dictionary["subscribed"] != nil  {
            return .Updated
        } else {
            return .Invalid
        }
    }
}
