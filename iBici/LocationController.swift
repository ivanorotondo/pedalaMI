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
    
    
    func mapView(mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        
        if regionDidChangeEnabled == true {
            addMarkersToTheMap(currentPoints)
        }
    }

    
}