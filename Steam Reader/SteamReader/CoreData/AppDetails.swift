import Foundation
import SwiftyJSON

@objc(AppDetails)
public class AppDetails: _AppDetails, JSONImportNSManagedObjectProtocol {
    
    // MARK: - JSONImportNSManagedObjectProtocol
    
    class func importDictionaryFromJSON(json: JSON, app: App?) -> [NSObject: AnyObject] {
        var genres: [String] = []
        for (_, subJSON):(String, JSON) in json["genres"] {
            genres.append(subJSON["description"].stringValue)
        }
        
        var categories: [String] = []
        for (_, subJSON):(String, JSON) in json["categories"] {
            categories.append(subJSON["description"].stringValue)
        }
        
        return [
            "appId" : app!.appId!,
            "headerImage" : json["header_image"].stringValue,
            "about" : json["about_the_game"].stringValue,
            "detailedDescription" : json["detailed_description"].stringValue,
            "releaseDate" : NSDate(timeIntervalSince1970: json["release_date", "date"].doubleValue),
            "website" : json["website"].stringValue,
            "price" : json["price_overview", "initial"].doubleValue,
            "currentPrice" : json["price_overview", "final"].doubleValue,
            "developers" : json["developers"].arrayObject ?? [],
            "publishers" : json["publishers"].arrayObject ?? [],
            "genres" : genres,
            "categories" : categories,
            "metacritic" : json["metacritic", "score"].stringValue,
            "metacriticScore" : json["metacritic", "url"].stringValue,
            "supportsWindows" : json["platforms", "windows"].boolValue,
            "supportsMac" : json["platforms", "mac"].boolValue,
            "supportsLinux" : json["platforms", "linux"].boolValue
        ]
    }
    
    class func importDictionaryMatches(dictionary: [NSObject : AnyObject], app: App?) -> ImportDictionaryMatchingState {
        let appDetails: AppDetails? = CoreDataInterface.singleton.appDetailsForApp(app!)
        if appDetails == nil {
            return .NewObject
        } else if (appDetails!.app?.appId)! == dictionary["appId"] as! String &&
            appDetails!.headerImage == (dictionary["headerImage"] as! String) &&
            appDetails!.about! == dictionary["about"] as! String &&
            appDetails!.detailedDescription! == dictionary["detailedDescription"] as! String &&
            appDetails!.website! == dictionary["website"] as! String &&
            appDetails!.releaseDate?.compare((dictionary["releaseDate"] as? NSDate)!) == .OrderedSame &&
            appDetails!.price == dictionary["price"] as! Double &&
            appDetails!.currentPrice == dictionary["currentPrice"] as! Double &&
            appDetails!.developers as! [String] == dictionary["developers"] as! [String] &&
            appDetails!.publishers as! [String] == dictionary["publishers"] as! [String] &&
            appDetails!.genres as! [String] == dictionary["genres"] as! [String] &&
            appDetails!.categories as! [String] == dictionary["categories"] as! [String] &&
            appDetails!.metacritic == (dictionary["metacritic"] as! String) &&
            appDetails!.metacriticScore == dictionary["metacriticScore"] as! String &&
            appDetails!.supportsWindows == dictionary["supportsWindows"] as! Bool &&
            appDetails!.supportsMac == dictionary["supportsMac"] as! Bool &&
            appDetails!.supportsLinux == dictionary["supportsLinux"] as! Bool {
            return .Matches
        } else if dictionary["appId"] != nil &&
            dictionary["headerImage"] != nil &&
            dictionary["about"] != nil &&
            dictionary["detailedDescription"] != nil &&
            dictionary["website"] != nil &&
            dictionary["releaseDate"] != nil &&
            dictionary["price"] != nil &&
            dictionary["currentPrice"] != nil &&
            dictionary["developers"] != nil &&
            dictionary["publishers"] != nil &&
            dictionary["genres"] != nil &&
            dictionary["categories"] != nil &&
            dictionary["metacritic"] != nil &&
            dictionary["metacriticScore"] != nil &&
            dictionary["supportsWindows"] != nil &&
            dictionary["supportsMac"] != nil &&
            dictionary["supportsLinux"] != nil {
            return .Updated
        } else {
            return .Invalid
        }
    }
}
