//
//  JSONImportNSManagedObjectProtocol.swift
//  SteamReader
//
//  Created by Kyle Roberts on 5/2/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import SwiftyJSON

enum ImportDictionaryMatchingState {
    case Matches, Updated, NewObject
}

protocol JSONImportNSManagedObjectProtocol {
    static func importDictionaryFromJSON(json: JSON, app: App?) -> [NSObject: AnyObject]
    static func importDictionaryMatches(dictionary: [NSObject : AnyObject], app: App?) -> ImportDictionaryMatchingState
}
