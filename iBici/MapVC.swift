//
//  ViewController.swift
//  iBici
//
//  Created by Ivano Rotondo on 11/03/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

//TODO: settings -> favorite default screen

import Foundation
import UIKit
import MapKit
import Mapbox

class MapVC: UIViewController, CLLocationManagerDelegate {

//MARK: - vars init
    let locationManager = CLLocationManager()

    let stationsURL = "http://www.bikemi.com/it/mappa-stazioni.aspx"
    var stationsHTML : NSString = ""
    var stationsArray : NSMutableArray = []
    var annotationsArray = [MGLAnnotation]()              //displayed annotations' array
    var subsetPointsAroundArray : NSMutableArray = []     //displayed stations' array
    var subsetPointsAroundArrayOLD : NSMutableArray = []  //displayed stations' array before update
    var currentView = ""
    var startingView = "bikes"
    var markersRemovedBecauseOfZooming = false
    var locationUserReached = false
    var menuIsShowed = false
    var tapWaterPointsArray : NSMutableArray = []
    var currentPoints = ""
    var startingPoints = "bikeStations"
    var regionDidChangeEnabled = false
    var addingMarkers = false
    
//MARK: outlet init
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet var tabBarView: UIView!
    
//MARK: outlet init Menu
    @IBOutlet var bikesButton: UIImageView!
    @IBOutlet var eBikesButton: UIImageView!
    @IBOutlet var slotsButton: UIImageView!
    @IBOutlet var refreshButton: UIImageView!
    
    @IBOutlet var settingsButton: UIImageView!
    @IBOutlet var myPositionButton: UIImageView!
    
    var pathsAreShowedDictionary : [String:Bool] = ["bikePaths" : false,
                                                    "pave" : false]
    var pointsAreShowedDictionary : [String:Bool] = ["bikeStations" : false,
                                                     "tapWaterPoints" : false]
    
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
    
//MARK: define map styles
    let cleanMapStyleUrl = NSURL(string: "mapbox://styles/ivanorotondo/ciluylzjp00rrc7lu80unjtnr")
    let paveMapStyleUrl = NSURL(string: "mapbox://styles/ivanorotondo/cimhl3rn40042ddm3zswcwt9l")
    let bikesPathAndPaveMapStyleUrl = NSURL(string: "mapbox://styles/ivanorotondo/cimhlfes20047ddm35i36h3hu")
    let bikesPathMapStyleUrl = NSURL(string: "mapbox://styles/ivanorotondo/cimhl440e0044d0mctwomptyj")
    
//MARK: - views init
    override func viewDidLoad() {
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        mapView.opaque = false
        mapView.compassView.hidden = true
        
        tapWaterPointsArray = ParsingSDK.parseTapWaterXML(tapWaterXML)
        
        pinTextFontAttributes = [NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
        ]
        
        currentView = startingView
        currentPoints = startingPoints
        showBikeStations()
        
        addTapRecognizersToTabBar()
        addTapRecognizersToMenu()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        regionDidChangeEnabled = true
    }
    
    func showBlankPage() {
        var blankPageVC = self.storyboard?.instantiateViewControllerWithIdentifier("BlankPageVC") as? BlankPageVC
        
        blankPageVC?.mapVC = self
        
        blankPageVC?.labelText = "Ops!\nError connection here"
        
        let newNavigationController = UINavigationController.init(rootViewController: blankPageVC!)
        newNavigationController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.showViewController(newNavigationController, sender: nil)
    }
}



