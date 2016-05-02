//
//  JSONImportNSManagedObjectProtocol.swift
//  SteamReader
//
//  Created by Kyle Roberts on 5/2/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import SwiftyJSON

protocol JSONImportNSManagedObjectProtocol {
    static func importDictionaryFromJSON(json: JSON) -> [NSObject: AnyObject]
}
