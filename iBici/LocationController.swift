//
//  LocationController.swift
//  pedalaMI
//
//  Created by Ivano Rotondo on 14/04/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Mapbox

extension MapViewController {
    
    //MARK: - locationManager
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            
            //            mapView.myLocationEnabled = true
            //            mapView.settings.myLocationButton = true
        } else {
            mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 45.4640976,longitude: 9.1919265), zoomLevel: 15, animated: false)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var currentLocation2D = (manager.location?.coordinate)

        let milanoLocation = CLLocation(latitude: 45.4640976,longitude: 9.1919265)
        let currentLocation = CLLocation(latitude: (currentLocation2D?.latitude)!, longitude:  (currentLocation2D?.longitude)!)

        if milanoLocation.distanceFromLocation(currentLocation) < 5000 {
            if manager.location?.horizontalAccuracy < 200 {
                
                mapView.setCenterCoordinate(currentLocation2D!, zoomLevel: 15, animated: false)
                manager.stopUpdatingLocation()

            }
            
        } else {
            mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 45.4640976,longitude: 9.1919265), zoomLevel: 15, animated: false)
            manager.stopUpdatingLocation()

        }
        
    }
    
    func centerMyLocation(sender: UITapGestureRecognizer){
        locationManager.startUpdatingLocation()
    }
        
    func mapView(mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        
        if regionDidChangeEnabled == true {
            if pointsAreShowedDictionary["bikeStations"] == true || pointsAreShowedDictionary["tapWaterPoints"] == true {
                
                if addingMarkers == false {
                    self.addMarkersToTheMap(self.currentPoints)
                }
            }
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
    
    


    
}