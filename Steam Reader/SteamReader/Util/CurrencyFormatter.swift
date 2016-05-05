//
//  CurrencyFormatter.swift
//  SteamReader
//
//  Created by Kyle Roberts on 5/5/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit

class CurrencyFormatter: NSNumberFormatter {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        
        numberStyle = .CurrencyStyle
    }
    
    func stringFromSteamPrice(price: NSNumber) -> String? {
        return stringFromNumber(NSNumber(double: price.doubleValue / 100.0))
    }
}
