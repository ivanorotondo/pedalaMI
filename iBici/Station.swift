//
//  Station.swift
//  pedalaMI
//
//  Created by Ivano Rotondo on 11/03/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Station : Hashable {
    var id : Int = 0
    var availableBikesNumber : Int = 0
    var availableElectricBikesNumber : Int = 0
    var availableSlotsNumber : Int = 0
    var stationName : String = ""
    var stationCoord : CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(0.0), Double(0.0))
    var stationActive : Bool = false
    var stationDistrict : String = ""
    var stationTotalSlotsNumber : Int = 0
    
    var hashValue: Int {
        return self.id
    }
    
    init(id: Int) {
        self.id = id
    }
    
}

func ==(lhs: Station, rhs: Station) -> Bool {
    return lhs.id == rhs.id
}