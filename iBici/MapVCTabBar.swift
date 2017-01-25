//
//  TabBarController.swift
//  pedalaMI
//
//  Created by Ivano Rotondo on 14/04/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Mapbox
//import Rollbar

extension MapVC {
    
    func addTapRecognizersToTabBar(){
        
        let tapBikes = UITapGestureRecognizer(target:self, action:Selector("addBikesMarkers:"))
        bikesItemView.addGestureRecognizer(tapBikes)
        
        let tapElectricBikes = UITapGestureRecognizer(target:self, action:Selector("addElectricBikesMarkers:"))
        eBikesItemView.addGestureRecognizer(tapElectricBikes)
        
        let tapSlots = UITapGestureRecognizer(target: self, action: Selector("addSlotsMarkers:"))
        slotsItemView.addGestureRecognizer(tapSlots)
                
    }
    
    
    func addBikesMarkers(sender: UITapGestureRecognizer) {
        if currentView != "bikes" {
            
            self.currentView = "bikes"
            self.updateTabBarItems()
            
            if markersRemovedBecauseOfZooming == false {
                
                subsetPointsAroundArrayOLD = []
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.mapView.removeAnnotations(self.annotationsArray)
                    self.annotationsArray = []
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.currentView = "bikes"
                        self.addMarkersToTheMap("bikeStations")
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
                
                subsetPointsAroundArrayOLD = []
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.mapView.removeAnnotations(self.annotationsArray)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.annotationsArray = []
                        self.currentView = "electricBikes"
                        self.addMarkersToTheMap("bikeStations")
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
                
                subsetPointsAroundArrayOLD = []
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.mapView.removeAnnotations(self.annotationsArray)
                    self.annotationsArray = []
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.currentView = "slots"
                        self.addMarkersToTheMap("bikeStations")
                    })
                })
                
            }
        }
    }
    
    
//    func refreshMarkers(sender: UITapGestureRecognizer) {
//        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            
//            if self.stationsArray == [] {
//                
//                Utilities.loadingBarDisplayer("",indicator:true, view: self.view)
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    
//                    self.addTapRecognizersToTabBar()
//                    self.updateTabBarItems()
//                    self.downloadAndShowStations()
//                })
//                
//            } else {
//                
//                Utilities.loadingBarDisplayer("",indicator:true, view: self.view)
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.subsetPointsAroundArrayOLD = []
//                    self.mapView.removeAnnotations(self.annotationsArray)
//                    self.addMarkersToTheMap("bikeStations")
//                })
//            }
//        })
//        
//    }

    
    func updateTabBarItems(){
        
        switch currentView {
        case "bikes":
            
            //set the backgrounds
            bikesItemBackground.hidden = false
            eBikesItemBackground.hidden = true
            slotsItemBackground.hidden = true
            //set the buttons
            bikesButton.image = UIImage(named: "bikeSelected")
            eBikesButton.image = UIImage(named: "eBikeUnselected")
            slotsButton.image = UIImage(named: "slotUnselected")
            
        case "electricBikes":
            //set the background
            bikesItemBackground.hidden = true
            eBikesItemBackground.hidden = false
            slotsItemBackground.hidden = true
            //set the buttons
            bikesButton.image = UIImage(named: "bikeUnselected")
            eBikesButton.image = UIImage(named: "eBikeSelected")
            slotsButton.image = UIImage(named: "slotUnselected")
            
        case "slots":
            //set the background
            bikesItemBackground.hidden = true
            eBikesItemBackground.hidden = true
            slotsItemBackground.hidden = false
            //set the buttons
            bikesButton.image = UIImage(named: "bikeUnselected")
            eBikesButton.image = UIImage(named: "eBikeUnselected")
            slotsButton.image = UIImage(named: "slotSelected")
            
        default:
            //set the backgrounds
            bikesItemBackground.hidden = false
            eBikesItemBackground.hidden = true
            slotsItemBackground.hidden = true
            //set the buttons
            bikesButton.image = UIImage(named: "bikeSelected")
            eBikesButton.image = UIImage(named: "eBikeUnselected")
            slotsButton.image = UIImage(named: "slotUnselected")

        }
        
    }
    

    
}