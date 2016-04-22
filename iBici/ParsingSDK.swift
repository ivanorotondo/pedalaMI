//
//  parsingSDK.swift
//  pedalaMI
//
//  Created by Ivano Rotondo on 11/03/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import UIKit

class ParsingSDK{
    
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
            let thisStation = Station(id: cycleNumber)
            
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
    
    
    
    static func parseTapWaterXML(tapWaterXML: String) -> NSMutableArray {
        //marker U=Via Vincenzo Monti, 55, 20123 Milano, Italia ID=phee8CBfnn4xYz lat=45.472267 lng=9.167421999999988 T=SI />
        
        let tapWaterPointsArray : NSMutableArray = []
        
        var (outputString, markerString) = ParsingSDK.setTheNewStartingPoint("<", inputString: tapWaterXML)
        
        print("\(markerString)")
        
        while outputString != "" {
            
            (outputString, markerString) = ParsingSDK.setTheNewStartingPoint("<", inputString: outputString)
            
            //    print("\(discardedString)")
            
            let tapWaterPoint = TapWaterPoint()
            
            tapWaterPoint.id = getValueFromXML(markerString, value: "ID=", endingPoint: " ") as String
            tapWaterPoint.name = getValueFromXML(markerString, value: "U=", endingPoint: ", Italia") as String
            tapWaterPoint.coordinate.latitude = Double(getValueFromXML(markerString, value: "lat=", endingPoint: " ") as String)!
            tapWaterPoint.coordinate.longitude = Double(getValueFromXML(markerString, value: "lng=", endingPoint: " ") as String)!
            
            let idPredicate = NSPredicate(format: "id = %@", "\(tapWaterPoint.id)")
            
            if (tapWaterPointsArray as NSMutableArray).filteredArrayUsingPredicate(idPredicate).count == 0 {
                tapWaterPointsArray.addObject(tapWaterPoint)
            }
            
            
            
        }
        
        return tapWaterPointsArray
    }
    
    static func getValueFromXML(markerString: NSString, value: String, endingPoint: String) -> NSString{
        
        let (stringFromValue, _) = ParsingSDK.setTheNewStartingPoint(value, inputString: markerString)
        
        let (_, valueString) = ParsingSDK.setTheNewStartingPoint(endingPoint, inputString: stringFromValue)
        //    print("\(valueString)")
        
        return valueString
    }

    
    
    
    
    
    static func setTheNewStartingPoint(startingString: String, inputString: NSString) -> (NSString,NSString){
        
        var outputString : NSString?
        var discardedString : NSString?
        
        

    //get the starting point
        let startingPoint : NSRange = inputString.rangeOfString(startingString)
        
        if startingPoint.length != 0 {
            //cut the original string from the END of the starting point, to the end of the string
            outputString = inputString.substringWithRange(NSRange(location: startingPoint.location + startingPoint.length, length: inputString.length - startingPoint.location - startingPoint.length))
            
            discardedString = inputString.substringWithRange(NSRange(location: 0, length: startingPoint.location))
            
            if outputString == nil {
                outputString = ""
            }
            if discardedString == nil {
                discardedString = ""
            }
        } else {
            outputString = ""
            discardedString = inputString
        }
        
        return (outputString!, discardedString!)
    }


}