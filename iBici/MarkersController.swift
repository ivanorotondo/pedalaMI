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

extension MapViewController {
    
    func addMarkersToTheMap(markerType: String){
        
        var allPointsArray : NSMutableArray = []
        
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
        
        var pointsToAddArray : NSMutableArray = []
        var pointsToRemoveArray : NSMutableArray = []
        var markersToRemoveArray : NSMutableArray = []
        
        func updateSubsetPointsAroundArrayOLD() {
            self.subsetPointsAroundArrayOLD = []
            for point in self.subsetPointsAroundArray {
                self.subsetPointsAroundArrayOLD.addObject(point)
            }
        }
        
        func getSetsAndRemoveOldAnnotations(){
            
            self.subsetPointsAroundArray = []
            self.subsetPointsAroundArray = self.getStationsAroundThisDistanceInMeters(800, allPointsArray: allPointsArray, pointsAroundArray: self.subsetPointsAroundArray, markerType: markerType) //contained into subsetStationsAroundArray
            
            (pointsToAddArray, pointsToRemoveArray) = self.getPointsToAddAndToRemoveArrays(self.subsetPointsAroundArray, pointsAroundArrayOLD: self.subsetPointsAroundArrayOLD, markerType: markerType)
            
            print("\n\n npoints to add array count\(pointsToAddArray.count) \n points to remove array count \(pointsToRemoveArray.count) \n\n")
            
            markersToRemoveArray = self.getMarkersArrayToRemoveFromAnnotationsArray(pointsToRemoveArray, markersToRemoveArray: markersToRemoveArray, markerType: markerType)
            
            updateSubsetPointsAroundArrayOLD()
            
            self.mapView.removeAnnotations(markersToRemoveArray as! [MGLAnnotation])
        }
        
        
        func addAnnotations(){
            //show the markers on the map
            for point in pointsToAddArray{
                
                var marker : MGLAnnotation?
                if markerType == "bikeStations"{
                    marker = self.getMarkerFromStation(self.currentView, station: point as! Station)
                } else {
                    marker = self.getMarkerFromTapWaterPoint(point as! TapWaterPoint)
                }
                self.annotationsArray.append(marker!)
                
                self.mapView.addAnnotation(marker!) //calls mapView(_: imageForAnnotation:)
                
            } //end for
        }
        
        addingMarkers = true
        dispatch_async(dispatch_queue_create("serial-worker", DISPATCH_QUEUE_SERIAL)) {
            
            getSetsAndRemoveOldAnnotations()
            
            dispatch_async(dispatch_get_main_queue(), {
                
                addAnnotations()
                self.addingMarkers = false
                
                Utilities.removeLoading()
            })
            

        }
        
    }
    
    
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        var text = NSString(string: " ")
        
        var annotationImage : MGLAnnotationImage?
        
        if annotation.subtitle != nil && annotation.title! != "Tap Water" {
            
            text = extractPinNumbersFromAnnotationSubtitle(annotation, text: text)
            annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("\(currentView) \(text)")
            
            if annotationImage == nil {
                
                let image = getTheImageCorrespondingToTheCurrentView()
                
                let resizedImage = setUpThePinImage(image, text: text)
                
                annotationImage = MGLAnnotationImage(image: resizedImage, reuseIdentifier: "\(currentView) \(text)")
            }
        }
        
        if annotation.title! == "Tap Water" {
            annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("tapWater")
            
            if annotationImage == nil {
                
                var image = UIImage(named: "pinTapWater")
                
                let size = CGSize(width: 17, height: 25)
                UIGraphicsBeginImageContext(size)
                image!.drawInRect(CGRectMake(0, 0, size.width, size.height))
                image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                annotationImage = MGLAnnotationImage(image: image!, reuseIdentifier: "tapWater")
            }
        }
        
        
        return annotationImage
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
        
        let marker = MGLPointAnnotation()
        marker.title = "\(station.stationName)"
        
        marker.subtitle = "\(subtitle) \(availabilityNumber)"
        
        marker.coordinate = CLLocationCoordinate2DMake(station.stationCoord.latitude, station.stationCoord.longitude)
        return marker
    }
    
    
    
    
    
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
    


    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    
}