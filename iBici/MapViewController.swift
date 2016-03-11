//
//  ViewController.swift
//  iBici
//
//  Created by Ivano Rotondo on 11/03/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import UIKit
import MapKit
import Mapbox

class MapViewController: UIViewController, CLLocationManagerDelegate {

//MARK: - vars init
    let stationsURL = "http://www.bikemi.com/it/mappa-stazioni.aspx"
    var stationsHTML : NSString = ""
    var stationsArray : NSMutableArray = []
    
    @IBOutlet var mapView: MGLMapView!
    
    let locationManager = CLLocationManager()

//MARK: - views init
    override func viewDidLoad() {
        

        
        getTheHTML(stationsURL){
            ParsingSDK.parseGoogleMapToObjects(self.stationsHTML, stationsArray: self.stationsArray)
            for station in self.stationsArray{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
               
                var marker = MGLPointAnnotation()
                marker.title = "\((station as? Station)!.stationName)"
                marker.subtitle = "Biciclette disponibili: \((station as? Station)!.availableBikesNumber)"
//                marker.icon = UIImage(named: "markerIconMini")
                marker.coordinate = CLLocationCoordinate2DMake(((station as? Station)?.stationCoord.latitude)!, ((station as? Station)?.stationCoord.longitude)!)
//                marker.map = self.mapView
                self.mapView.addAnnotation(marker)
                })
            }
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("marker")
        
        if annotationImage == nil {
            
            var image = UIImage(named: "markerIconMini")!
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "marker")
        }
        
        return annotationImage
    }
    
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
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            
//            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//            
//            locationManager.stopUpdatingLocation()
//        }
//    }
}



