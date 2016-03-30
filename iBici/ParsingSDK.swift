//
//  parsingSDK.swift
//  pedalaMI
//
//  Created by Ivano Rotondo on 11/03/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import UIKit

class ParsingSDK {
    
    static func parseGoogleMapToObjects(inputString: NSString, stationsArray: NSMutableArray){
        
/* Input example
        
        GoogleMap.addMarker(
        '/media/assets/images/station_map/more_than_five_bikes_flag.png',
        45.464683238626,
        9.18879747390747,
        'Duomo',
        '\u003cdiv style=\"width: 240px; height: 120px;\"\u003e\u003cspan style=\"font-weight: bold;\"\u003e1 - Duomo\u003c/span\u003e\u003cbr/\u003e\u003cul\u003e\u003cli\u003e
        Biciclette disponibili: 14\u003c/li\u003e\u003cli\u003e
        Biciclette elettriche disponibili: 8\u003c/li\u003e\u003cli\u003e
        Stalli disponibili: 1\u003c/li\u003e\u003c/ul\u003e\u003c/div\u003e');
*/
        
        let input = inputString
        let startingPointString = "GoogleMap.addMarker"
        let startingPointComma = ","
        let startingAvailableBikesNumber = "Biciclette disponibili: "
        let startingAvailableElectricBikesNumber = "Biciclette elettriche disponibili: "
        let startingAvailableSlotsNumber = "Stalli disponibili: "
        
        var cycleNumber = 0
        
        var (inputSubString, discardedString) = setTheNewStartingPoint(startingPointString, inputString: input)
        
        func parsing(cycleNumber : Int) {
            var thisStation = Station(id: cycleNumber)
            
        //y coord value
            (inputSubString, discardedString) = setTheNewStartingPoint(startingPointComma, inputString: inputSubString)
            (inputSubString, discardedString) = setTheNewStartingPoint(startingPointComma, inputString: inputSubString)
            
            thisStation.stationCoord.latitude = Double(discardedString.doubleValue)

        //x coord value
            (inputSubString, discardedString) = setTheNewStartingPoint(startingPointComma, inputString: inputSubString)
            thisStation.stationCoord.longitude = Double(discardedString.doubleValue)
            
        //station name
            (inputSubString, discardedString) = setTheNewStartingPoint(startingPointComma, inputString: inputSubString)
            thisStation.stationName = (discardedString.stringByReplacingOccurrencesOfString("'", withString: "")).stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet())
            print("\(thisStation.stationName)")
            
            
        //available bikes number
            (inputSubString, discardedString) = setTheNewStartingPoint(startingAvailableBikesNumber, inputString: inputSubString)
            (inputSubString, discardedString) = setTheNewStartingPoint(startingAvailableElectricBikesNumber, inputString: inputSubString)
            thisStation.availableBikesNumber = Int((discardedString.substringWithRange(NSRange(location: 0, length: discardedString.rangeOfString("\\").location)) as NSString).intValue)
            
        //available electric bikes number
            (inputSubString, discardedString) = setTheNewStartingPoint(startingAvailableSlotsNumber, inputString: inputSubString)
            thisStation.availableElectricBikesNumber = Int((discardedString.substringWithRange(NSRange(location: 0, length: discardedString.rangeOfString("\\").location)) as NSString).intValue)
            
        //available slots
            if inputSubString.rangeOfString(startingPointString).location < 99999999 {
                
                (inputSubString, discardedString) = setTheNewStartingPoint(startingPointString, inputString: inputSubString)
            } else {
                
                (inputSubString, discardedString) = setTheNewStartingPoint("</script>", inputString: inputSubString)
            }
            thisStation.availableSlotsNumber = Int((discardedString.substringWithRange(NSRange(location: 0, length: discardedString.rangeOfString("\\").location)) as NSString).intValue)
            
            stationsArray.addObject(thisStation)
            
        }
        
        
        while inputSubString.rangeOfString(startingPointString).length != 0{
            
            parsing(cycleNumber)
            cycleNumber += 1
        }
        
        parsing(cycleNumber)
        
    }
    
    static func setTheNewStartingPoint(startingString: String, inputString: NSString) -> (NSString,NSString){
        
        var outputString : NSString?
        var discardedString : NSString?
        
        

    //get the starting point
        let startingPoint = inputString.rangeOfString(startingString)
        
    //cut the original string from the END of the starting point, to the end of the string
        outputString = inputString.substringWithRange(NSRange(location: startingPoint.location + startingPoint.length, length: inputString.length - startingPoint.location - startingPoint.length))
        
        discardedString = inputString.substringWithRange(NSRange(location: 0, length: startingPoint.location))
        
        if outputString == nil {
            outputString = ""
        }
        if discardedString == nil {
            discardedString = ""
        }
        
        return (outputString!, discardedString!)
    }


}