//
//  AboutMeVC.swift
//  pedalaMI
//
//  Created by Ivo on 07/12/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import UIKit

class AboutMeVC : UIViewController {
    
    var aboutMeLabelText = "Ivano Rotondo\na Sicilian iOS developer.\n\nivano.rotondo@gmail.com\n"
    var acknowledgementsLabelText = "Chiara Cacciola: graphic design\nAlessia Rotondo: scriptwriter\nMassimo Sbaraccani: logos"
    
    @IBOutlet var aboutMeLabel: UILabel!
    @IBOutlet var acknowledgementsLabel: UILabel!
    @IBOutlet var closeButton: UIButton!

    override func viewDidLoad() {
        
        self.navigationController?.navigationBarHidden = true
        
        aboutMeLabel.text = aboutMeLabelText
        acknowledgementsLabel.text = acknowledgementsLabelText
        
        closeButton.backgroundColor = UIColor.clearColor()
        closeButton.layer.cornerRadius = 5
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = darkGrayColor.CGColor
    }
    
    
    @IBAction func closeButtonPressed(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: {})
    }
    
}