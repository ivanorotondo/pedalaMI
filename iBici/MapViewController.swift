//
//  ViewController.swift
//  iBici
//
//  Created by Ivano Rotondo on 11/03/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

//TODO: settings -> favorite default screen

import UIKit
import MapKit
import Mapbox
import Gifu

class MapViewController: UIViewController, CLLocationManagerDelegate {

//MARK: - vars init
    let locationManager = CLLocationManager()

    let stationsURL = "http://www.bikemi.com/it/mappa-stazioni.aspx"
    var stationsHTML : NSString = ""
    var stationsArray : NSMutableArray = []
    var annotationsArray = [MGLAnnotation]()                //displayed annotations' array
    var subsetStationsAroundArray : NSMutableArray = []     //displayed stations' array
    var subsetStationsAroundArrayOLD : NSMutableArray = []  //displayed stations' array before update
    var currentView = ""
    var startingView = "bikes"
    var markersRemovedBecauseOfZooming = false
    var locationUserReached = false
    
//MARK: outlet init
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet var bikesButton: UIImageView!
    @IBOutlet var eBikesButton: UIImageView!
    @IBOutlet var slotsButton: UIImageView!
    @IBOutlet var refreshButton: UIImageView!
    @IBOutlet var settingsButton: UIImageView!
    
//MARK: outlet init TabBar
    @IBOutlet var bikesItemBackground: UIImageView!
    @IBOutlet var eBikesItemBackground: UIImageView!
    @IBOutlet var slotsItemBackground: UIImageView!

    @IBOutlet var eBikesItemView: UIView!
    @IBOutlet var bikesItemView: UIView!
    @IBOutlet var slotsItemView: UIView!

//MARK: pin text variables
    let textColor : UIColor = UIColor.whiteColor()
    let textFont : UIFont = UIFont(name: "Helvetica Bold", size: 15)!
    var pinTextFontAttributes = NSDictionary()
    
//MARK: - views init
    override func viewDidLoad() {
        
        pinTextFontAttributes = [NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
        ]
        
        mapView.styleURL = NSURL(string: "mapbox://styles/ivanorotondo/ciluylzjp00rrc7lu80unjtnr")
        
        currentView = startingView
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            Utilities.loadingBarDisplayer("",indicator:true, view: self.view)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.addTapRecognizerToButtons()
                self.updateTabBarItems()
                self.downloadAndShowStations()
            })
        })

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    func addTapRecognizerToButtons(){
        
        let tapBikes = UITapGestureRecognizer(target:self, action:Selector("addBikesMarkers:"))
        bikesItemView.addGestureRecognizer(tapBikes)
        
        let tapElectricBikes = UITapGestureRecognizer(target:self, action:Selector("addElectricBikesMarkers:"))
        eBikesItemView.addGestureRecognizer(tapElectricBikes)
     
        let tapSlots = UITapGestureRecognizer(target: self, action: Selector("addSlotsMarkers:"))
        slotsItemView.addGestureRecognizer(tapSlots)
        
        let tapRefresh = UITapGestureRecognizer(target: self, action: Selector("refreshMarkers:"))
        
        refreshButton.userInteractionEnabled = true
        refreshButton.addGestureRecognizer(tapRefresh)
        
        let tapSettings = UITapGestureRecognizer(target: self, action: Selector("showMenu:"))
        
        settingsButton.userInteractionEnabled = true
        settingsButton.addGestureRecognizer(tapSettings)
        
    }
    
    func updateTabBarItems(){
        
        switch currentView {
            case "bikes":
                
              //set the backgrounds
                bikesItemBackground.hidden = false
                eBikesItemBackground.hidden = true
                slotsItemBackground.hidden = true
              //set the buttons
                bikesButton.image = UIImage(named: "bikeSelected.png")
                eBikesButton.image = UIImage(named: "eBikeUnselected.png")
                slotsButton.image = UIImage(named: "slotUnselected.png")
              //set the other buttons
                refreshButton.image = UIImage(named: "refreshBike.png")
                settingsButton.image = UIImage(named: "menuBike.png")

            case "electricBikes":
              //set the background
                bikesItemBackground.hidden = true
                eBikesItemBackground.hidden = false
                slotsItemBackground.hidden = true
              //set the buttons
                bikesButton.image = UIImage(named: "bikeUnselected.png")
                eBikesButton.image = UIImage(named: "eBikeSelected.png")
                slotsButton.image = UIImage(named: "slotUnselected.png")
                //set the other buttons
                refreshButton.image = UIImage(named: "refreshEBike.png")
                settingsButton.image = UIImage(named: "menuEBike.png")
            
            case "slots":
              //set the background
                bikesItemBackground.hidden = true
                eBikesItemBackground.hidden = true
                slotsItemBackground.hidden = false
              //set the buttons
                bikesButton.image = UIImage(named: "bikeUnselected.png")
                eBikesButton.image = UIImage(named: "eBikeUnselected.png")
                slotsButton.image = UIImage(named: "slotSelected.png")
                //set the other buttons
                refreshButton.image = UIImage(named: "refreshSlot.png")
                settingsButton.image = UIImage(named: "menuSlot.png")
            
            default:
                //set the backgrounds
                bikesItemBackground.hidden = false
                eBikesItemBackground.hidden = true
                slotsItemBackground.hidden = true
                //set the buttons
                bikesButton.image = UIImage(named: "bikeSelected.png")
                eBikesButton.image = UIImage(named: "eBikeUnselected.png")
                slotsButton.image = UIImage(named: "slotUnselected.png")
                //set the other buttons
                refreshButton.image = UIImage(named: "refreshBike.png")
                settingsButton.image = UIImage(named: "menuBike.png")
        }
        
    }
    
    func downloadAndShowStations(){
        getStationsDataFromRemoteServer({
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.addMarkersToTheMap(self.currentView)
            })
        }, unsuccess:{
        
        })
    }
//        getTheHTML(stationsURL){
//            ParsingSDK.parseGoogleMapToObjects(self.stationsHTML, stationsArray: self.stationsArray)
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                
//                self.addMarkersToTheMap(self.currentView)
//            })
//        }
    
    


    func extractPinNumbersFromAnnotationSubtitle(annotation: MGLAnnotation, var text: NSString) -> NSString {
        var subtitle = (annotation.subtitle! as! String?)
        let numberIndex = (subtitle?.startIndex.distanceTo((subtitle?.characters.indexOf(":"))!))! + 2
        let subtitleNSString = NSString(string: "\(subtitle!)")
        text = subtitleNSString.substringWithRange(NSRange(location: numberIndex, length: (subtitle?.characters.count)! - numberIndex))
        return text
    }
    
    func getTheImageCorrespondingToTheCurrentView() -> UIImage{
        
            var image = UIImage(named: "pinBike")!
            
            switch currentView {
            case "bikes":
                image = UIImage(named: "pinBike")!
            case "electricBikes":
                image = UIImage(named: "pinEBike")!
            case "slots":
                image = UIImage(named: "pinSlot")!
            default:
                image = UIImage(named: "pinBike")!
            }
        
        return image
    }
    
    func setUpThePinImage(image: UIImage, text: NSString)-> UIImage{
        
        //set up the pin image
        let size = CGSize(width: 25, height: 25)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        var rect: CGRect = CGRectMake(8.5, 4, size.width, size.width)
        
        if text.length == 1 {
            rect = CGRectMake(8.5, 4, size.width, size.width)
        }
        if text.length == 2 {
            rect = CGRectMake(4.5, 4, size.width, size.width)
        }
        
        text.drawInRect(rect, withAttributes: pinTextFontAttributes as? [String : AnyObject])
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    

//    func mapView(mapView: MGLMapView, regionDidChangeAnimated animated: Bool){
//        
//        print ("\(self.mapView.zoomLevel)")
//        if self.mapView.zoomLevel < 13 {
//            mapView.removeAnnotations(annotationsArray)
//        } else {
//            mapView.addAnnotations(annotationsArray)
//        }
//        
//    }

    
//TODO:
//    func mapViewRegionIsChanging(mapView: MGLMapView) {
//        if self.mapView.zoomLevel < 12 && markersRemovedBecauseOfZooming == false {
//            markersRemovedBecauseOfZooming = true
//           // mapView.removeAnnotations(annotationsArray)
//        } else if self.mapView.zoomLevel > 12 && markersRemovedBecauseOfZooming == true{
//            markersRemovedBecauseOfZooming = false
//            //mapView.addAnnotations(annotationsArray)
//        }
//    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
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
    
    
    
//MARK: - locationManager

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()

//            mapView.myLocationEnabled = true
//            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if manager.location?.horizontalAccuracy < 200 && locationUserReached == false {
            
            mapView.setCenterCoordinate((manager.location?.coordinate)!, zoomLevel: 15, animated: false)
            locationUserReached = true
        }
    }

//stop updating location
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            
//            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//            
//            locationManager.stopUpdatingLocation()
//        }
//    }
    
    
    func addBikesMarkers(sender: UITapGestureRecognizer) {
        if currentView != "bikes" {
            
            self.currentView = "bikes"
            self.updateTabBarItems()
            
            if markersRemovedBecauseOfZooming == false {
                
                subsetStationsAroundArrayOLD = []
                dispatch_async(dispatch_get_main_queue(), { () -> Void in

                    self.mapView.removeAnnotations(self.annotationsArray)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in

                        self.addMarkersToTheMap("bikes")
                    })
                })
            }

        }

    }
    
    func addElectricBikesMarkers(sender: UITapGestureRecognizer) {
        if currentView != "electricBikes" {
            
            self.currentView = "electricBikes"
            self.updateTabBarItems()

            if markersRemovedBecauseOfZooming == false {
                
                subsetStationsAroundArrayOLD = []
                dispatch_async(dispatch_get_main_queue(), { () -> Void in

                    self.mapView.removeAnnotations(self.annotationsArray)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in

                        self.addMarkersToTheMap("electricBikes")
                    })
                })
            }
        }
    }
    
    func addSlotsMarkers(sender: UITapGestureRecognizer) {
        if currentView != "slots" {
            
            self.currentView = "slots"
            self.updateTabBarItems()
            
            if markersRemovedBecauseOfZooming == false {
                
                subsetStationsAroundArrayOLD = []
                dispatch_async(dispatch_get_main_queue(), { () -> Void in

                    self.mapView.removeAnnotations(self.annotationsArray)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in

                        self.addMarkersToTheMap("slots")
                    })
                })
                
            }
        }
    }
    
    func refreshMarkers(sender: UITapGestureRecognizer) {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            if self.stationsArray == [] {
                
                Utilities.loadingBarDisplayer("",indicator:true, view: self.view)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.addTapRecognizerToButtons()
                    self.updateTabBarItems()
                    self.downloadAndShowStations()
                })
            
            } else {
            
                Utilities.loadingBarDisplayer("",indicator:true, view: self.view)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.subsetStationsAroundArrayOLD = []
                    self.mapView.removeAnnotations(self.annotationsArray)
                    self.addMarkersToTheMap(self.currentView)
                })
            }
        })
        
    }
    
    func showMenu(sender: UITapGestureRecognizer) {
        self.slideMenuController()?.openLeft()
    }
    
    func mapView(mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        addMarkersToTheMap(currentView)
    }
    
    
    func addMarkersToTheMap(bikesType: String){
        
    //  {
        self.getStationsAroundThisDistanceInMeters(800) //contained into subsetStationsAroundArray
        
        
        var (stationsToAddArray, stationsToRemoveArray) = self.getStationsToAddAndToRemoveArrays()
        
        var markersToRemoveArray : NSMutableArray = []
        markersToRemoveArray = self.getMarkersArrayToRemoveFromAnnotationsArray(stationsToRemoveArray, markersArray: markersToRemoveArray)
        
        self.subsetStationsAroundArrayOLD = []
        for station in self.subsetStationsAroundArray {
            self.subsetStationsAroundArrayOLD.addObject(station)
        }
        
        self.mapView.removeAnnotations(markersToRemoveArray as! [MGLAnnotation])
   // } ~> {
//show the markers on the map
        for station in stationsToAddArray{
                
            var marker = self.getMarkerFromStation(bikesType, station: station as! Station)
            self.annotationsArray.append(marker)

//            Utilities.backgroundThread(0, background: {
                self.mapView.addAnnotation(marker) //calls mapView(_: imageForAnnotation:)
//            })

        } //end for
        
        
    //
        Utilities.transparentFrame.removeFromSuperview()
        Utilities.loadingAnimationImageView.removeFromSuperview()
        Utilities.messageFrame.removeFromSuperview()
      }
    //}
    
    
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        var text = NSString(string: " ")
        
        if annotation.subtitle != nil{
            
            text = extractPinNumbersFromAnnotationSubtitle(annotation, text: text)
        }
        
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("\(currentView) \(text)")
        
        if annotationImage == nil {
            
            let image = getTheImageCorrespondingToTheCurrentView()
            
            let resizedImage = setUpThePinImage(image, text: text)
            
            annotationImage = MGLAnnotationImage(image: resizedImage, reuseIdentifier: "\(currentView) \(text)")
        }
        
        return annotationImage
    }
    
    
    func getStationsAroundThisDistanceInMeters(distance: Double) {
        
        subsetStationsAroundArray = []

    //get the locations of every station wrt the center of the map
        for station in self.stationsArray{
            let a = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            let b = CLLocation(latitude: ((station as? Station)?.stationCoord.latitude)!, longitude: ((station as? Station)?.stationCoord.longitude)!)
            if a.distanceFromLocation(b) < distance {
                subsetStationsAroundArray.addObject(station)
            }
        }
    }
    
    
    func getStationsToAddAndToRemoveArrays() -> (NSMutableArray, NSMutableArray) {
        
        //create the set of new and old stations
        var newStationsAroundSet = Set<Station>()
        for station in subsetStationsAroundArray {
            newStationsAroundSet.insert(station as! Station)
        }
        
        var oldStationsAroundSet = Set<Station>()
        for station in subsetStationsAroundArrayOLD {
            oldStationsAroundSet.insert(station as! Station)
        }
        
        //create the set of the differences
        let stationsToAddSet = newStationsAroundSet.subtract(oldStationsAroundSet)
        let stationsToRemoveSet = oldStationsAroundSet.subtract(newStationsAroundSet)
        
        //turn to arrays
        var stationsToAddArray : NSMutableArray = []
        for station in stationsToAddSet {
            stationsToAddArray.addObject(station)
        }
        
        var stationsToRemoveArray : NSMutableArray = []
        for station in stationsToRemoveSet {
            stationsToRemoveArray.addObject(station)
        }

        return(stationsToAddArray, stationsToRemoveArray)
    }
    
    func getMarkerFromStation(bikesType: String, station: Station) -> MGLAnnotation {
        
        var availabilityNumber = ""
        var subtitle = ""
        
        switch bikesType {
            case "bikes":
                subtitle = "Biciclette disponibili:"
                availabilityNumber = "\(station.availableBikesNumber)"
            case "electricBikes":
                subtitle = "Biciclette elettriche disponibili:"
                availabilityNumber = "\(station.availableElectricBikesNumber)"
            case "slots":
                subtitle = "Parcheggi disponibili:"
                availabilityNumber = "\(station.availableSlotsNumber)"
            default:
                subtitle = "Biciclette disponibili:"
                availabilityNumber = "\(station.availableBikesNumber)"
        }
        
        var marker = MGLPointAnnotation()
        marker.title = "\(station.stationName)"
        
        marker.subtitle = "\(subtitle) \(availabilityNumber)"
        
        marker.coordinate = CLLocationCoordinate2DMake(((station as? Station)?.stationCoord.latitude)!, ((station as? Station)?.stationCoord.longitude)!)
        return marker
    }
    
    func getMarkersArrayToRemoveFromAnnotationsArray(stationsToRemoveArray: NSMutableArray, markersArray: NSMutableArray) -> NSMutableArray{
        
        for station in stationsToRemoveArray {
            
            var indexToRemove = Int()
            
            for (index, annotation) in annotationsArray.enumerate() {
                if annotation.title! == (station as? Station)?.stationName {
                    markersArray.addObject(annotation)
                    indexToRemove = index
                }
            }
            
            annotationsArray.removeAtIndex(indexToRemove as! Int)
            
            
           // markersArray.addObject(getMarkerFromStation(currentView, station: station as! Station))
        }
        
        return markersArray
    }
    
    
    
        
}



