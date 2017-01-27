//
//  AboutMeVC.swift
//  pedalaMI
//
//  Created by Ivo on 07/12/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import UIKit
import MessageUI


class AboutMeVC : UIViewController, MFMailComposeViewControllerDelegate {
    
    var aboutMeLabelText = "Coded with ♡ by\n\nIvano Rotondo\na Sicilian iOS developer."
    var acknowledgementsLabelText = "pedalaMI was possible thanks to \n\nChiara Cacciola   ||   UI/UX\nAlessia Rotondo   ||   copy\nMassimo Sbaraccani   ||   logo\nGiulio Stramondo   ||   code support"
    
    @IBOutlet var aboutMeLabel: UILabel!
    @IBOutlet var acknowledgementsLabel: UILabel!
    @IBOutlet var closeButton: UIButton!

    override func viewDidLoad() {
        
        self.navigationController?.navigationBarHidden = true
        
        let aboutMeLabelMutableAttributedString = Utilities.makeThisSubstringBold(aboutMeLabelText, substringsArray: ["Ivano Rotondo"])
        aboutMeLabel.attributedText = Utilities.getAttributedText(aboutMeLabelMutableAttributedString, lineSpacing: 4.0, alignment: .Center)
        var acknowledgementsLabelMutableAttributedString = Utilities.makeThisSubstringBold(acknowledgementsLabelText, substringsArray: ["Chiara Cacciola", "Alessia Rotondo", "Massimo Sbaraccani","Giulio Stramondo"])
        acknowledgementsLabel.attributedText = Utilities.getAttributedText(acknowledgementsLabelMutableAttributedString, lineSpacing: 4.0, alignment: .Center)
        
        closeButton.backgroundColor = UIColor.clearColor()
        closeButton.layer.cornerRadius = 5
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = darkGrayColor.CGColor
        
//        addTapMailGesture()
    }
    
    
    @IBAction func closeButtonPressed(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: {})
    }
}