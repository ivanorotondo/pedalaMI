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
    
    override func viewDidLoad() {
        menuTableView.rowHeight = UITableViewAutomaticDimension
        menuTableView.estimatedRowHeight = 200.0
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell : IconCell = tableView.dequeueReusableCellWithIdentifier("IconCell")! as! IconCell
            cell.iconImage.image = UIImage(named: "pinBike.png")
            cell.label.text = "Bike paths"
            
            if mapVC?.pathsAreShowedDictionary["bikePaths"] == true {
                cell.label.font = fontBold16
            } else {
                cell.label.font = fontRegular16
            }
            return cell
        }
        
        if indexPath.row == 1 {
            let cell : IconCell = tableView.dequeueReusableCellWithIdentifier("IconCell")! as! IconCell
            cell.iconImage.image = UIImage(named: "pinBike.png")
            cell.label.text = "Pavé"
            
            if mapVC?.pathsAreShowedDictionary["pave"] == true {
                cell.label.font = fontBold16
            } else {
                cell.label.font = fontRegular16
            }
            return cell
        }
        
        if indexPath.row == 2 {
            let cell : IconCell = tableView.dequeueReusableCellWithIdentifier("IconCell")! as! IconCell
            cell.iconImage.image = UIImage(named: "pinBike.png")
            cell.label.text = "Bike stations"
            return cell
        }
        
        if indexPath.row == 3 {
            let cell : IconCell = tableView.dequeueReusableCellWithIdentifier("IconCell")! as! IconCell
            cell.iconImage.image = UIImage(named: "pinBike.png")
            cell.label.text = "Tap water"
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
                cell.label.font = fontBold16
            } else {
                cell.label.font = fontRegular16
            }
//            self.slideMenuController()?.closeRight()
        }
        
        if indexPath.row == 1 {
            mapVC?.pathSwitch("pave")
            
            if mapVC?.pathsAreShowedDictionary["pave"] == true {
                cell.label.font = fontBold16
            } else {
                cell.label.font = fontRegular16
            }
//            self.slideMenuController()?.closeRight()
        }
        
        if indexPath.row == 2 {
            mapVC?.pinsSwitch("bikeStationPoints")
//            self.slideMenuController()?.closeRight()
        }
        
        if indexPath.row == 3 {
            mapVC?.pinsSwitch("tapWaterPoints")
        }
    }
}

class locationTrackingMenuOptionCell : UITableViewCell {
    
}

class IconCell : UITableViewCell {

    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var label: UILabel!
}