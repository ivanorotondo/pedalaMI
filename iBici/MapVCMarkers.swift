//
//  MarkersController.swift
//  pedalaMI
//
//  Created by Ivano Rotondo on 14/04/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import UIKit
import Mapbox
import MapKit

extension MapVC {
    
    func addMarkersToTheMap(markerType: String){
        
        var allPointsArray : NSMutableArray = []
        var pointsToAddArray : NSMutableArray = []
        var pointsToRemoveArray : NSMutableArray = []
        var markersToRemoveArray : NSMutableArray = []
        
        
        switch markerType {
        case "bikeStations":
           allPointsArray = self.stationsArray
            break
        case "tapWaterPoints":
           allPointsArray = self.tapWaterPointsArray
            break
        default:
           allPointsArray = []
            break
        }
        
        
        func updateSubsetPointsAroundArrayOLD() {
            self.subsetPointsAroundArrayOLD = []
            for point in self.subsetPointsAroundArray {
                self.subsetPointsAroundArrayOLD.addObject(point)
            }
        }
        

        func getStationsAroundThisDistanceInMeters(distance: Double, allPointsArray: NSMutableArray,pointsAroundArray: NSMutableArray, markerType: String) -> NSMutableArray {
            
            //get the locations of every point wrt the center of the map
            for point in allPointsArray{
                let a = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
                var b = CLLocation()
                
                if markerType == "bikeStations" {
                    b = CLLocation(latitude: ((point as? Station)?.stationCoord.latitude)!, longitude: ((point as? Station)?.stationCoord.longitude)!)
                } else { // "tapWaterPoints"
                    b = CLLocation(latitude: ((point as? TapWaterPoint)?.coordinate.latitude)!, longitude: ((point as? TapWaterPoint)?.coordinate.longitude)!)
                }
                
                if a.distanceFromLocation(b) < distance {
                    pointsAroundArray.addObject(point)
                }
            }
            return pointsAroundArray
        }
        
        
        func getMarkersArrayToRemoveFromAnnotationsArray(pointsToRemoveArray: NSMutableArray,markersToRemoveArray: NSMutableArray, markerType: String) -> NSMutableArray{
            
            for point in pointsToRemoveArray {
                
                var indexToRemove = Int()
                
                for (index, annotation) in annotationsArray.enumerate() {
                    if markerType == "bikeStations" {
                        if annotation.title! == (point as? Station)?.stationName {
                            print("index to remove: \(indexToRemove)")
                            print("annotationsArray count: \(annotationsArray.count)")
                            print("annotation title: \(annotation.title)")
                            markersToRemoveArray.addObject(annotation)
                            indexToRemove = index
                            annotationsArray.removeAtIndex(indexToRemove as! Int)
                            
                        }
                    } else {
                        if annotation.coordinate.longitude == (point as? TapWaterPoint)?.coordinate.longitude && annotation.coordinate.latitude == (point as? TapWaterPoint)?.coordinate.latitude {
                            markersToRemoveArray.addObject(annotation)
                            indexToRemove = index
                            annotationsArray.removeAtIndex(indexToRemove as! Int)
                        }
                    }
                }
                
                
                
                // allPointsArray.addObject(getMarkerFromStation(currentView, station: station as! Station))
            }
            
            return markersToRemoveArray
        }
        
        
        func getPointsToAddAndToRemoveArrays(pointsAroundArray: NSMutableArray, pointsAroundArrayOLD: NSMutableArray, markerType: String) -> (NSMutableArray, NSMutableArray) {
            
            var pointsToAddArray : NSMutableArray = []
            var pointsToRemoveArray : NSMutableArray = []
            
            
            switch markerType{
            case "bikeStations":
                
                //create the set of new and old stations
                var newStationsAroundSet = Set<Station>()
                for station in pointsAroundArray {
                    newStationsAroundSet.insert(station as! Station)
                }
                
                var oldStationsAroundSet = Set<Station>()
                for station in pointsAroundArrayOLD {
                    oldStationsAroundSet.insert(station as! Station)
                }
                
                //create the set of the differences
                let stationsToAddSet = newStationsAroundSet.subtract(oldStationsAroundSet)
                let stationsToRemoveSet = oldStationsAroundSet.subtract(newStationsAroundSet)
                
                //turn to arrays
                for station in stationsToAddSet {
                    pointsToAddArray.addObject(station)
                }
                
                for station in stationsToRemoveSet {
                    pointsToRemoveArray.addObject(station)
                }
                
                break
            case "tapWaterPoints":
                
                //create the set of new and old tap waters
                var newTapWaterPointAroundSet = Set<TapWaterPoint>()
                for tapWaterPoint in pointsAroundArray {
                    newTapWaterPointAroundSet.insert(tapWaterPoint as! TapWaterPoint)
                }
                
                var oldTapWaterPointAroundSet = Set<TapWaterPoint>()
                for tapWaterPoint in pointsAroundArrayOLD {
                    oldTapWaterPointAroundSet.insert(tapWaterPoint as! TapWaterPoint)
                }
                
                //create the set of the differences
                let tapWaterPointsToAddSet = newTapWaterPointAroundSet.subtract(oldTapWaterPointAroundSet)
                let tapWaterPointsToRemoveSet = oldTapWaterPointAroundSet.subtract(newTapWaterPointAroundSet)
                
                //turn to arrays
                for tapWaterPoint in tapWaterPointsToAddSet {
                    pointsToAddArray.addObject(tapWaterPoint)
                }
                
                for tapWaterPoint in tapWaterPointsToRemoveSet {
                    pointsToRemoveArray.addObject(tapWaterPoint)
                }
                
                break
            default:
                break
            }
            
            return(pointsToAddArray, pointsToRemoveArray)
        }
        
        
        func getMarkerFromTapWaterPoint(tapWaterPoint: TapWaterPoint) -> MGLAnnotation {
            let marker = MGLPointAnnotation()
            marker.title = "Tap Water"
            marker.subtitle = "\(tapWaterPoint.name)"
            
            marker.coordinate = CLLocationCoordinate2DMake(tapWaterPoint.coordinate.latitude, tapWaterPoint.coordinate.longitude)
            
            return marker
        }
        
        
        func getMarkerFromStation(bikesType: String, station: Station) -> MGLAnnotation {
            
            var availabilityNumber = ""
            var subtitle = ""
            
            switch bikesType {
            case "bikes":
                subtitle = "Available bikes:"
                availabilityNumber = "\(station.availableBikesNumber)"
            case "electricBikes":
                subtitle = "Available electric bikes:"
                availabilityNumber = "\(station.availableElectricBikesNumber)"
            case "slots":
                subtitle = "Available slots:"
                availabilityNumber = "\(station.availableSlotsNumber)"
            default:
                subtitle = "Available bikes:"
                availabilityNumber = "\(station.availableBikesNumber)"
            }
            
            let marker = MGLPointAnnotation()
            marker.title = "\(station.stationName)"
            
            marker.subtitle = "\(subtitle) \(availabilityNumber)"
            
            marker.coordinate = CLLocationCoordinate2DMake(station.stationCoord.latitude, station.stationCoord.longitude)
            return marker
        }
        
        
        func getSetsAndRemoveOldAnnotations(){
            
            self.subsetPointsAroundArray = []
            self.subsetPointsAroundArray = getStationsAroundThisDistanceInMeters(800, allPointsArray: allPointsArray, pointsAroundArray: self.subsetPointsAroundArray, markerType: markerType) //contained into subsetStationsAroundArray
            
            (pointsToAddArray, pointsToRemoveArray) = getPointsToAddAndToRemoveArrays(self.subsetPointsAroundArray, pointsAroundArrayOLD: self.subsetPointsAroundArrayOLD, markerType: markerType)
            
            print("\n\n npoints to add array count\(pointsToAddArray.count) \n points to remove array count \(pointsToRemoveArray.count) \n\n")
            
            markersToRemoveArray = getMarkersArrayToRemoveFromAnnotationsArray(pointsToRemoveArray, markersToRemoveArray: markersToRemoveArray, markerType: markerType)
            
            updateSubsetPointsAroundArrayOLD()
            
            self.mapView.removeAnnotations(markersToRemoveArray as! [MGLAnnotation])
        }
        
        
        func addAnnotations(){
            for point in pointsToAddArray{
                
                var marker : MGLAnnotation?
                if markerType == "bikeStations"{
                    marker = getMarkerFromStation(self.currentView, station: point as! Station)
                } else {
                    marker = getMarkerFromTapWaterPoint(point as! TapWaterPoint)
                }
                self.annotationsArray.append(marker!)
                
                self.mapView.addAnnotation(marker!) //calls mapView(_: imageForAnnotation:)
                
            } //end for
        }
        
        addingMarkers = true
//        dispatch_async(dispatch_queue_create("serial-worker", DISPATCH_QUEUE_SERIAL)) {
        
            getSetsAndRemoveOldAnnotations()
            
            dispatch_async(dispatch_get_main_queue(), {
                
                addAnnotations()
                self.addingMarkers = false
                
                Utilities.removeLoading()
            })
            

//        }
        
    }
    
    
    func mapView(mapView: MGLMapView, viewForAnnotation annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        func extractPinNumbersFromAnnotationSubtitle(annotation: MGLAnnotation) -> NSString {
            var subtitle = (annotation.subtitle! as! String?)
            let numberIndex = (subtitle?.startIndex.distanceTo((subtitle?.characters.indexOf(":"))!))! + 2
            let subtitleNSString = NSString(string: "\(subtitle!)")
            return subtitleNSString.substringWithRange(NSRange(location: numberIndex, length: (subtitle?.characters.count)! - numberIndex))
        }

        guard annotation is MGLPointAnnotation else {
            return nil
        }
        

        let reuseIdentifier = "\(annotation.coordinate.latitude)\(annotation.coordinate.longitude)"
        
        var  annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
        annotationView.frame = CGRectMake(0, 0, 30, 30)
        
        if annotation.title! != "Tap Water" {
            
            annotationView.tag = Int(extractPinNumbersFromAnnotationSubtitle(annotation) as String)!

            switch currentView {
            case "bikes":
                annotationView.backgroundColor = orangeColor
            case "electricBikes":
                annotationView.backgroundColor = redColor
            case "slots":
                annotationView.backgroundColor = grayColor
            default:
                annotationView.backgroundColor = orangeColor
            }
        } else {
            annotationView.tag = -1
        }

        return annotationView
    }

    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    
    
    func mapView(mapView: AnyObject!, didAddAnnotationViews annotationViews: AnyObject!) {
        addBounceAnimationToView(annotationViews as! [MGLAnnotationView])
    }
    
    
    func addBounceAnimationToView(viewsArray: [MGLAnnotationView]) {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        bounceAnimation.values = [0.05, 1.1, 0.9, 1]
        bounceAnimation.duration = 0.6
        
        let timingFunctions = NSMutableArray(capacity: bounceAnimation.values!.count)

        let bounceAnimationCount = bounceAnimation.values?.count
        
        var i = 1
        while i <= bounceAnimationCount {
            timingFunctions.addObject(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
            i = i + 1
        }
        
        bounceAnimation.timingFunctions = (timingFunctions as! [CAMediaTimingFunction])
        bounceAnimation.removedOnCompletion = false
        
        for view in viewsArray {
            view.layer.addAnimation(bounceAnimation, forKey: "bounce")
        }
    }
    
    
    func mapViewDidFinishLoadingMap(mapView: MGLMapView) {
        print("finished")
    }
}

