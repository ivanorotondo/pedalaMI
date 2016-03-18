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

class MapViewController: UIViewController, CLLocationManagerDelegate {

//MARK: - vars init
    let locationManager = CLLocationManager()

    let stationsURL = "http://www.bikemi.com/it/mappa-stazioni.aspx"
    var stationsHTML : NSString = ""
    var stationsArray : NSMutableArray = []
    var annotationsArray = [MGLAnnotation]()
    var currentView = ""
    var startingView = "bikes"
    
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
    
//MARK: - views init
    override func viewDidLoad() {
        
        mapView.styleURL = NSURL(string: "mapbox://styles/ivanorotondo/ciluylzjp00rrc7lu80unjtnr")
        
        currentView = startingView
        
        addTapRecognizerToButtons()
        updateTabBarItems()
        downloadAndShowStations()
        
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

        
      //      var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(currentView)
            var image = UIImage(named: "pinBike")!

            switch currentView {
                case "bikes":
       //             annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(currentView)
        //            if annotationImage == nil {
                        image = UIImage(named: "pinBike")!
        //            }
                
                case "electricBikes":
         //           annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(currentView)
       //             if annotationImage == nil {
                    image = UIImage(named: "pinEBike")!
         //       }
                case "slots":
         //           annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(currentView)
         //           if annotationImage == nil {
                    image = UIImage(named: "pinSlot")!
         //       }
                default:
        //            annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(currentView)
         //           if annotationImage == nil {
                    image = UIImage(named: "pinBike")!
        //            }
            }
        
            var text = NSString(string: " ")

            if annotation.subtitle != nil{
                var subtitle = (annotation.subtitle! as! String?)
                let numberIndex = (subtitle?.startIndex.distanceTo((subtitle?.characters.indexOf(":"))!))! + 2
                let subtitleNSString = NSString(string: "\(subtitle!)")
                text = subtitleNSString.substringWithRange(NSRange(location: numberIndex, length: (subtitle?.characters.count)! - numberIndex))
            }
        
            let textColor: UIColor = UIColor.whiteColor()
            let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 15)!
            let textFontAttributes = [
                NSFontAttributeName: textFont,
                NSForegroundColorAttributeName: textColor,
            ]
        
            let size = CGSize(width: 25, height: 25)
            UIGraphicsBeginImageContext(size)
            image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
            var rect: CGRect = CGRectMake(8.5, 4, size.width, size.width)

        print("\(text)")
            if text.length == 1 {
                rect = CGRectMake(8.5, 4, size.width, size.width)
            }
            if text.length == 2 {
                rect = CGRectMake(4.5, 4, size.width, size.width)
            }
        
            text.drawInRect(rect, withAttributes: textFontAttributes)
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            var annotationImage = MGLAnnotationImage(image: resizedImage, reuseIdentifier: "\(currentView) \(text)")
        
        return annotationImage
    }

//TODO:
//    func mapView(mapView: MGLMapView, regionDidChangeAnimated animated: Bool){
//        
//        print ("\(self.mapView.zoomLevel)")
//        if self.mapView.zoomLevel < 12.5 {
//            mapView.removeAnnotations(annotationsArray)
//        } else {
//            //add previous annotations
//        }
//        
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
            mapView.removeAnnotations(annotationsArray)
            currentView = "bikes"
            updateTabBarItems()
            addMarkersToTheMap("bikes")
        }

    }
    
    func addElectricBikesMarkers(sender: UITapGestureRecognizer) {
        if currentView != "electricBikes" {
            mapView.removeAnnotations(annotationsArray)
            currentView = "electricBikes"
            updateTabBarItems()
            addMarkersToTheMap("electricBikes")
        }
    }
    
    func addSlotsMarkers(sender: UITapGestureRecognizer) {
        if currentView != "slots" {
            mapView.removeAnnotations(annotationsArray)
            currentView = "slots"
            updateTabBarItems()
            addMarkersToTheMap("slots")
        }
    }
    
    func refreshMarkers(sender: UITapGestureRecognizer) {
        mapView.removeAnnotations(annotationsArray)
        addMarkersToTheMap(currentView)
    }
    
    func showMenu(sender: UITapGestureRecognizer) {
        self.slideMenuController()?.openRight()
    }
    
    func addMarkersToTheMap(bikesType: String){
        
        var availabilityNumber = ""
        var subtitle = ""
        
        for station in self.stationsArray{
            
            switch bikesType {
                case "bikes":
                    subtitle = "Biciclette disponibili:"
                    availabilityNumber = "\((station as? Station)!.availableBikesNumber)"
                case "electricBikes":
                    subtitle = "Biciclette elettriche disponibili:"
                    availabilityNumber = "\((station as? Station)!.availableElectricBikesNumber)"
                case "slots":
                    subtitle = "Parcheggi disponibili:"
                    availabilityNumber = "\((station as? Station)!.availableSlotsNumber)"
                default:
                    print("\n\nerror\n\n")
            }
            
                var marker = MGLPointAnnotation()
                marker.title = "\((station as? Station)!.stationName)"
            
                marker.subtitle = "\(subtitle) \(availabilityNumber)"
            
                marker.coordinate = CLLocationCoordinate2DMake(((station as? Station)?.stationCoord.latitude)!, ((station as? Station)?.stationCoord.longitude)!)
                self.mapView.addAnnotation(marker)
                annotationsArray.append(marker)
            
        }
    }
    
    
    
    
    
}



