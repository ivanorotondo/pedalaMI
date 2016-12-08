//
//  Colors.swift
//  pedalaMI
//
//  Created by Ivo on 06/12/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import UIKit

var orangeColor = Utilities.uiColorGivenHex(0xF4A14C, alpha: 1)
//var redColor = Utilities.uiColorGivenHex(0xFF3E31, alpha: 1)
var redColor = Utilities.uiColorGivenHex(0xE42028, alpha: 1)
var grayColor = Utilities.uiColorGivenHex(0x9F9091, alpha: 1)
var darkGrayColor = Utilities.uiColorGivenHex(0x595959, alpha: 1)

extension Utilities {
    
    static func uiColorGivenHex(inputHex: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red:(CGFloat((inputHex & 0xFF0000) >> 16))/255.0,
                       green:(CGFloat((inputHex & 0xFF00) >> 8))/255.0,
                       blue:(CGFloat(inputHex & 0xFF))/255.0,
                       alpha: alpha)
    }
    
}