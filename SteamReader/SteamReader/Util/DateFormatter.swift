//
//  DateFormatter.swift
//  SteamReader
//
//  Created by Kyle Roberts on 5/5/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit

class DateFormatter: NSDateFormatter {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        
        dateStyle = .ShortStyle
    }

}
