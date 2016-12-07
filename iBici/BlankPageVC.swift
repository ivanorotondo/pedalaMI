//
//  BlankPageVC.swift
//  pedalaMI
//
//  Created by Ivo on 07/12/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import UIKit


class BlankPageVC : UIViewController {
    
    var mapVC : MapViewController?
    
    @IBOutlet var label: UILabel!
    
    var labelText = ""
    
    override func viewDidLoad() {
        label.text = labelText
        
        self.navigationController?.navigationBarHidden = true
    }
    
    @IBAction func tryAgainButtonPressed(sender: UIButton) {
        mapVC?.downloadAndShowStations({
            self.dismissViewControllerAnimated(true, completion: {})
            }, fail: {})
    }
}