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

class Station {
    var availableBikesNumber : Int = 0
    var availableElectricBikesNumber : Int = 0
    var availableSlotsNumber : Int = 0
    var stationName : String = ""
    var stationCoord : CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(0.0), Double(0.0))
}