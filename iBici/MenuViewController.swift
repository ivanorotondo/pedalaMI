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
    
    override func viewDidLoad() {
        menuTableView.rowHeight = UITableViewAutomaticDimension
        menuTableView.estimatedRowHeight = 200.0
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var cell : locationTrackingMenuOptionCell = (tableView.dequeueReusableCellWithIdentifier("locationTrackingMenuOptionCell") as? locationTrackingMenuOptionCell)!
        
        return cell
    }
}

class locationTrackingMenuOptionCell : UITableViewCell {
    
}