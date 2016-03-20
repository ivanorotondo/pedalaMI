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
        
        getTheHTML(stationsURL){
            ParsingSDK.parseGoogleMapToObjects(self.stationsHTML, stationsArray: self.stationsArray)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.addMarkersToTheMap(self.currentView)
            })
        }
    }
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        
        var text = NSString(string: " ")
        
//extract pin numbers
        if annotation.subtitle != nil{
            var subtitle = (annotation.subtitle! as! String?)
            let numberIndex = (subtitle?.startIndex.distanceTo((subtitle?.characters.indexOf(":"))!))! + 2
            let subtitleNSString = NSString(string: "\(subtitle!)")
            text = subtitleNSString.substringWithRange(NSRange(location: numberIndex, length: (subtitle?.characters.count)! - numberIndex))
        }
        
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("\(currentView) \(text)")
        
//        print("\(text)")
//        print("\(annotationImage)")
        
        if annotationImage == nil {
        
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
            
            annotationImage = MGLAnnotationImage(image: resizedImage, reuseIdentifier: "\(currentView) \(text)")
        }
        
        return annotationImage
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
    func getTheHTML(destination: String, success:()->()){
        
        var HTMLString : NSString?
        
        
        ServerCallsSDK.askTheTRKServer(destination, method: "GET",
            successHandler: {
                (response) in
                
                self.stationsHTML = NSString(data: response, encoding: NSUTF8StringEncoding)!
                success()
            },
            errorHandler: {
                (response) in
                
                print("falliu")
            
            }
        )
        
        if HTMLString == nil {
            HTMLString = ""
        }
       

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
                mapView.removeAnnotations(annotationsArray)
                addMarkersToTheMap("bikes")
            }

        }

    }
    
    func addElectricBikesMarkers(sender: UITapGestureRecognizer) {
        if currentView != "electricBikes" {
            
            self.currentView = "electricBikes"
            self.updateTabBarItems()

            if markersRemovedBecauseOfZooming == false {
                
                subsetStationsAroundArrayOLD = []
                mapView.removeAnnotations(annotationsArray)
                addMarkersToTheMap("electricBikes")
            }
        }
    }
    
    func addSlotsMarkers(sender: UITapGestureRecognizer) {
        if currentView != "slots" {
            
            self.currentView = "slots"
            self.updateTabBarItems()
            
            if markersRemovedBecauseOfZooming == false {
                
                subsetStationsAroundArrayOLD = []
                mapView.removeAnnotations(annotationsArray)
                addMarkersToTheMap("slots")
                
            }
        }
    }
    
    func refreshMarkers(sender: UITapGestureRecognizer) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            Utilities.loadingBarDisplayer("",indicator:true, view: self.view)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.subsetStationsAroundArrayOLD = []
                self.mapView.removeAnnotations(self.annotationsArray)
                self.addMarkersToTheMap(self.currentView)
            })
        })
        
    }
    
    func showMenu(sender: UITapGestureRecognizer) {
        self.slideMenuController()?.openLeft()
    }
    
    func mapView(mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        addMarkersToTheMap(currentView)
    }
    
    
    func addMarkersToTheMap(bikesType: String){
        
        getStationsAround(800) //contained into subsetStationsAroundArray
        
        var (stationsToAddArray, stationsToRemoveArray) = getStationsToAddAndRemoveArrays()
        
        var markersToRemoveArray : NSMutableArray = []
        markersToRemoveArray = getMarkersArrayToRemoveFromAnnotationsArray(stationsToRemoveArray, markersArray: markersToRemoveArray)
        
        self.mapView.removeAnnotations(markersToRemoveArray as! [MGLAnnotation])

        
//show the markers on the map
        for station in stationsToAddArray{
            
            var marker = getMarkerFromStation(bikesType, station: station as! Station)
            
                self.mapView.addAnnotation(marker)
                annotationsArray.append(marker)
            
        } //end for
        
        
        subsetStationsAroundArrayOLD = []
        
        for station in subsetStationsAroundArray {
            subsetStationsAroundArrayOLD.addObject(station)
        }
        
//
        Utilities.transparentFrame.removeFromSuperview()
        Utilities.loadingAnimationImageView.removeFromSuperview()
        Utilities.messageFrame.removeFromSuperview()
        
    }
    
    
    func getStationsAround(distance: Double) {
        
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
    
    
    func getStationsToAddAndRemoveArrays() -> (NSMutableArray, NSMutableArray) {
        
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
    
    func getMarkersArrayToRemoveFromAnnotationsArray(stationsArray: NSMutableArray, markersArray: NSMutableArray) -> NSMutableArray{
        
        for station in stationsArray {
            
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



