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
            var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("bikePathCell")!
            return cell
        }
        
        if indexPath.row == 1 {
            var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("paveCell")!
            return cell
        }
        
        if indexPath.row == 2 {
            var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("bikeStationsCell")!
            return cell
        }
        
        if indexPath.row == 3 {
            var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("tapWaterCell")!
            return cell
        }
        
        let cell = UITableViewCell()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 2 {
            mapVC?.pinsSwitch("bikeStationPoints")
            self.slideMenuController()?.closeRight()
        }
        
        if indexPath.row == 3 {
            mapVC?.pinsSwitch("tapWaterPoints")
        }
    }
}

class locationTrackingMenuOptionCell : UITableViewCell {
    
}