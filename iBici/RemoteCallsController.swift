//
//  RemoteCallsController.swift
//  pedalaMI
//
//  Created by Ivano Rotondo on 14/04/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation


extension MapViewController {
    
    
    func downloadAndShowStations(){
        getStationsDataFromRemoteServer({
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.addMarkersToTheMap("bikeStations")
            })
            }, unsuccess:{
                
        })
    }
    
    
    //MARK: - getTheHTML call
    func getStationsDataFromRemoteServer(success:()->(), unsuccess:()->()) {
        let dataPost = "{\"Version\":\"1.0\",\"Action\":\"GetStations\",\"Hash\":\"AF2704FC4DD32B39C058DB3904EC8C88\"}"
        let destination = "http://89.251.178.41:8080/BikeMiService/api"
        
        let headersDict : NSDictionary = [
            "9474DB0A-2F20-41C1-B562-F78828BFD324" : "HardwareId",
            "application/json; charset=UTF-8" : "Content-Type",
            "file://" : "Origin",
            "Mozilla/5.0 (iPhone; CPU iPhone OS 9_2_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13D15 (5174136032)" : "User-Agent",
            "iOS" : "PlatformType"
        ]
        
        ServerCallsSDK.askTheTRKServerWithData(dataPost, destination: destination, method: "POST", headersDict: headersDict, successHandler:{
            (response) in
            let responseString = NSString(data: response, encoding: NSUTF8StringEncoding)
            print("\(responseString)")
            do{
                let parsedObject: AnyObject? = try NSJSONSerialization.JSONObjectWithData(response,
                    options: NSJSONReadingOptions.AllowFragments)
                
                
                //response parsing
                if let jsonDictionary = parsedObject as? NSDictionary,
                    let resultDict = jsonDictionary["Result"] as? NSDictionary,
                    let resultStationsArray = resultDict["Stations"] as? NSArray{
                    for station in resultStationsArray {
                        
                        if let stationDict = station as? NSDictionary,
                            let stationNumber = stationDict["Number"] as? Int{
                            var thisStation = Station(id: stationNumber)
                            
                            if let stationName = stationDict["Name"] as? String{
                                thisStation.stationName = stationName
                            }
                            if let stationDistrict = stationDict["District"] as? String{
                                thisStation.stationDistrict = stationDistrict
                            }
                            if let stationLatitude = stationDict["Latitude"] as? Double{
                                thisStation.stationCoord.latitude = stationLatitude
                            }
                            if let stationLongitude = stationDict["Longitude"] as? Double{
                                thisStation.stationCoord.longitude = stationLongitude
                            }
                            if let stationActive = stationDict["Active"] as? Bool{
                                thisStation.stationActive = stationActive
                            }
                            if let stationTotalSlotsNumber = stationDict["SlotsNumber"] as? Int{
                                thisStation.stationTotalSlotsNumber = stationTotalSlotsNumber
                            }
                            if let stationAvailability = stationDict["Availability"] as? NSDictionary{
                                if let stationAvailableBikes = stationAvailability["BikesNumber"] as? Int{
                                    thisStation.availableBikesNumber = stationAvailableBikes
                                }
                                if let stationAvailableEBikes = stationAvailability["EBikesNumber"] as? Int{
                                    thisStation.availableElectricBikesNumber = stationAvailableEBikes
                                }
                                if let stationAvailableSlots = stationAvailability["FreeSlotsNumber"] as? Int{
                                    thisStation.availableSlotsNumber = stationAvailableSlots
                                }
                            }
                            
                            self.stationsArray.addObject(thisStation)
                        }
                        
                    }//end for
                    success()
                }
                
            } catch {
                print("sticazzi")
            }
            
            }, errorHandler: {
                (error) in
                
                if error == -1009 {
                    var alertNoInternetConnection = Utilities.AlertTextualDetails()
                    alertNoInternetConnection.title = "The device results offline"
                    alertNoInternetConnection.message = "No internet connection available"
                    Utilities.displayAlert(self, alertTextualDetails: alertNoInternetConnection)
                } else if error == -1001{
                    var alertRequestTimeout = Utilities.AlertTextualDetails()
                    alertRequestTimeout.title = "Slow Connection"
                    alertRequestTimeout.message = "It took too long to download data"
                    Utilities.displayAlert(self, alertTextualDetails: alertRequestTimeout)
                } else {
                    var alertUnknownError = Utilities.AlertTextualDetails()
                    alertUnknownError.title = "Error"
                    alertUnknownError.message = "Unknown error"
                    Utilities.displayAlert(self, alertTextualDetails: alertUnknownError)
                }
                unsuccess()
            }
            
        )
        
    }
}