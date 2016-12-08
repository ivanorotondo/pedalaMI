//
//  MenuViewController.swift
//  pedalaMI
//
//  Created by Ivano Rotondo on 13/03/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var menuTableView: UITableView!
    
    var mapVC : MapViewController?
    var containerVC : ContainerViewController?
    
    override func viewDidLoad() {
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        menuTableView.rowHeight = UITableViewAutomaticDimension
        menuTableView.estimatedRowHeight = 200.0
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell : IconCell = tableView.dequeueReusableCellWithIdentifier("IconCell")! as! IconCell
            cell.iconImage.image = UIImage(named: "bikePathsIcon.png")
            dispatch_async(dispatch_get_main_queue(), {
                cell.iconImage.layer.frame.origin.y = cell.iconImage.layer.frame.origin.y + 5
                cell.iconImage.layer.frame.size.height = cell.iconImage.layer.frame.height - 10
            })
            cell.label.text = "Bike paths"
            
            if mapVC?.pathsAreShowedDictionary["bikePaths"] == true {
                cell.label.font = fontBold18
            } else {
                cell.label.font = fontRegular18
            }
            return cell
        }
        
        if indexPath.row == 1 {
            let cell : IconCell = tableView.dequeueReusableCellWithIdentifier("IconCell")! as! IconCell
            cell.iconImage.image = UIImage(named: "paveIcon.png")
            dispatch_async(dispatch_get_main_queue(), {
                cell.iconImage.layer.frame.origin.y = cell.iconImage.layer.frame.origin.y + 3
                cell.iconImage.layer.frame.size.height = cell.iconImage.layer.frame.height - 6
            })
            cell.label.text = "Pavé"
            
            if mapVC?.pathsAreShowedDictionary["pave"] == true {
                cell.label.font = fontBold18
            } else {
                cell.label.font = fontRegular18
            }
            return cell
        }
        
        if indexPath.row == 2 {
            let cell : IconCell = tableView.dequeueReusableCellWithIdentifier("IconCell")! as! IconCell
            cell.iconImage.image = UIImage(named: "bikeStationsIcon.png")
            cell.label.text = "Bike stations"
            if mapVC?.pointsAreShowedDictionary["bikeStations"] == false {
                cell.label.font = fontBold18
            } else {
                cell.label.font = fontRegular18
            }
            return cell
        }
        
        if indexPath.row == 3 {
            let cell : IconCell = tableView.dequeueReusableCellWithIdentifier("IconCell")! as! IconCell
            cell.iconImage.image = UIImage(named: "pinTapWater.png")
            dispatch_async(dispatch_get_main_queue(), {
                cell.iconImage.layer.frame.origin.y = cell.iconImage.layer.frame.origin.y + 3
                cell.iconImage.layer.frame.size.height = cell.iconImage.layer.frame.height - 6
            })
            cell.label.text = "Tap water"
            if mapVC?.pointsAreShowedDictionary["tapWaterPoints"] == true {
                cell.label.font = fontBold18
            } else {
                cell.label.font = fontRegular18
            }
            return cell
        }
        
        if indexPath.row == 4 {
            let cell : IconCell = tableView.dequeueReusableCellWithIdentifier("IconCell")! as! IconCell
            cell.iconImage.image = UIImage(named: "aboutMeIcon.png")
            dispatch_async(dispatch_get_main_queue(), {
                cell.iconImage.layer.frame.origin.y = cell.iconImage.layer.frame.origin.y + 4
                cell.iconImage.layer.frame.size.height = cell.iconImage.layer.frame.height - 8
            })
            cell.label.text = "About me"
            return cell
        }
        
        let cell = UITableViewCell()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! IconCell
        
        if indexPath.row == 0 {
            mapVC?.pathSwitch("bikePaths")
            
            if mapVC?.pathsAreShowedDictionary["bikePaths"] == true {
                cell.label.font = fontBold18
            } else {
                cell.label.font = fontRegular18
            }
//            self.slideMenuController()?.closeRight()
        }
        
        if indexPath.row == 1 {
            mapVC?.pathSwitch("pave")
            
            if mapVC?.pathsAreShowedDictionary["pave"] == true {
                cell.label.font = fontBold18
            } else {
                cell.label.font = fontRegular18
            }
//            self.slideMenuController()?.closeRight()
        }
        
        if indexPath.row == 2 {
            let tapWaterCell = tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: 3, inSection: 0)) as! IconCell
            if mapVC?.pointsAreShowedDictionary["bikeStations"] == false {
                cell.label.font = fontBold18
                if mapVC?.pointsAreShowedDictionary["tapWaterPoints"] == true {
                    tapWaterCell.label.font = fontRegular18
                }
            } else {
                cell.label.font = fontRegular18
            }
            
            
            mapVC?.pinsSwitch("bikeStationPoints")

//            self.slideMenuController()?.closeRight()
        }
        
        if indexPath.row == 3 {
            let bikeStationsCell = tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: 2, inSection: 0)) as! IconCell

            if mapVC?.pointsAreShowedDictionary["tapWaterPoints"] == false {
                cell.label.font = fontBold18
                if mapVC?.pointsAreShowedDictionary["bikeStations"] == true {
                    bikeStationsCell.label.font = fontRegular18
                }
            } else {
                cell.label.font = fontRegular18
            }
            
            mapVC?.pinsSwitch("tapWaterPoints")
        }
        
        if indexPath.row == 4 {
            self.slideMenuController()?.closeRight()
            showAboutMe()
        }
    }
    
    func showAboutMe() {
        var aboutMeVC = self.storyboard?.instantiateViewControllerWithIdentifier("AboutMeVC") as? AboutMeVC
        
        let newNavigationController = UINavigationController.init(rootViewController: aboutMeVC!)
        newNavigationController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        containerVC?.showViewController(newNavigationController, sender: nil)
    }
}

class locationTrackingMenuOptionCell : UITableViewCell {}

class IconCell : UITableViewCell {

    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var label: UILabel!
}

