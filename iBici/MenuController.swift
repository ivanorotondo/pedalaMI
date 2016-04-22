//
//  MenuController.swift
//  pedalaMI
//
//  Created by Ivano Rotondo on 11/04/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Mapbox

extension MapViewController {
    
    func addTapRecognizersToMenu() {
        let tapSettings = UITapGestureRecognizer(target: self, action: #selector(MapViewController.animateMenuControllerTap(_:)))
        
        settingsButton.userInteractionEnabled = true
        settingsButton.addGestureRecognizer(tapSettings)
        
        let tapBikePaths = UITapGestureRecognizer(target: self, action: #selector(MapViewController.menuPathsSwitchController(_:)))
        bikePathsButton.tag = 1
        bikePathsButton.userInteractionEnabled = false
        bikePathsButton.addGestureRecognizer(tapBikePaths)
        
        let tapPavePaths = UITapGestureRecognizer(target: self, action: #selector(MapViewController.menuPathsSwitchController(_:)))
        paveButton.tag = 2
        paveButton.userInteractionEnabled = false
        paveButton.addGestureRecognizer(tapPavePaths)
        
        let tapBikeStations = UITapGestureRecognizer(target: self, action: #selector(MapViewController.menuPointsSwitchController(_:)))
        bikeStationsButton.tag = 10
        bikeStationsButton.userInteractionEnabled = false
        bikeStationsButton.addGestureRecognizer(tapBikeStations)
        
        let tapTapWaterPoints = UITapGestureRecognizer(target: self, action: #selector(MapViewController.menuPointsSwitchController(_:)))
        tapWaterButton.tag = 20
        tapWaterButton.userInteractionEnabled = false
        tapWaterButton.addGestureRecognizer(tapTapWaterPoints)
        
        let tapMyPosition = UITapGestureRecognizer(target: self, action: #selector(MapViewController.centerMyLocation(_:)))
        myPositionButton.userInteractionEnabled = true
        myPositionButton.addGestureRecognizer(tapMyPosition)
    }
    
    
    func menuPathsSwitchController(sender: UITapGestureRecognizer){
        
        switch sender.view!.tag{
            
        case 1:
            pathSwitch("bikePaths")
            break
            
        case 2:
            pathSwitch("pave")
            break
            
        default:
            break
            
        }
    }
    
    func menuPointsSwitchController(sender: UITapGestureRecognizer){
        
        switch sender.view!.tag{
            
        case 10:
            if currentPoints == "bikeStations" {
                
                currentPoints = "bikeStations"
                
                if pointsAreShowedDictionary["bikeStations"] == false{
                    
                    showBikeStations()
                    
                } else {
                    
                    hideBikeStations()
                }
            }
            if currentPoints == "tapWaterPoints" {
                hideTapWaterPoints()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.currentPoints = "bikeStations"
                    self.showBikeStations()
                })
            }
            break
            
        case 20:
            if currentPoints == "tapWaterPoints" {
                if pointsAreShowedDictionary["tapWaterPoints"] == false{
                    currentPoints = "tapWaterPoints"
                    
                    showTapWaterPoints()
                    
                } else {
                    
                    hideTapWaterPoints()
                }
            }
            if currentPoints == "bikeStations" {
                self.hideBikeStations()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.currentPoints = "tapWaterPoints"
                    self.showTapWaterPoints()
                })
            }
            break
            
        default:
            break
            
        }
        
        
        
        
    }

    
    func pathSwitch(buttonTapped: String){
        
        if buttonTapped == "bikePaths" {
            
            if pathsAreShowedDictionary["bikePaths"] == false {
                if pathsAreShowedDictionary["pave"] == false {
                    showBikePaths()
                } else {
                    showBikePathsAndPave()
                }
                pathsAreShowedDictionary["bikePaths"] = true
            } else {
                if pathsAreShowedDictionary["pave"] == false {
                    showCleanMap()
                } else {
                    showPave()
                }
                pathsAreShowedDictionary["bikePaths"] = false
            }
            
        }
        
        if buttonTapped == "pave" {
            if pathsAreShowedDictionary["pave"] == false {
                if pathsAreShowedDictionary["bikePaths"] == false {
                    showPave()
                } else {
                    showBikePathsAndPave()
                }
                pathsAreShowedDictionary["pave"] = true
            } else {
                if pathsAreShowedDictionary["bikePaths"] == false {
                    showCleanMap()
                } else {
                    showBikePaths()
                }
                pathsAreShowedDictionary["pave"] = false
            }
        }
        
    }
    
    
    
    func showTapWaterPoints(){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.addMarkersToTheMap("tapWaterPoints")
            self.pointsAreShowedDictionary["tapWaterPoints"] = true
            
        })
    }
    
    func hideTapWaterPoints(){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.subsetPointsAroundArrayOLD = []
            self.mapView.removeAnnotations(self.annotationsArray)
            self.annotationsArray = []
            self.pointsAreShowedDictionary["tapWaterPoints"] = false
            
        })
    }
    
    func showBikeStations(){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            Utilities.loadingBarDisplayer("",indicator:true, view: self.view)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.currentView = self.startingView
                self.updateTabBarItems()
                self.downloadAndShowStations()
                self.pointsAreShowedDictionary["bikeStations"] = true
                self.tabBarView.hidden = false
                self.tabBarView.userInteractionEnabled = true
            })
        })
    }
    
    func hideBikeStations(){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.subsetPointsAroundArrayOLD = []
            self.mapView.removeAnnotations(self.annotationsArray)
            self.annotationsArray = []
            self.pointsAreShowedDictionary["bikeStations"] = false
            self.tabBarView.hidden = true
            self.tabBarView.userInteractionEnabled = false
        })
    }
    

    func showBikePaths() {
        
        mapView.styleURL = bikesPathMapStyleUrl
    }
    
    func showPave() {
        
        mapView.styleURL = paveMapStyleUrl
    }
    
    func showBikePathsAndPave(){
        
        mapView.styleURL = bikesPathAndPaveMapStyleUrl
    }
    
    func showCleanMap(){
        
        mapView.styleURL = cleanMapStyleUrl
    }
    
}