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
    
    var aboutMeLabelText = "Ivano Rotondo\na Sicilian iOS developer.\n"
    var acknowledgementsLabelText = "Chiara Cacciola: graphic design\nAlessia Rotondo: scriptwriter\nMassimo Sbaraccani: logos"
    
    @IBOutlet var aboutMeLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
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
        
        addTapMailGesture()
    }
    
    
    @IBAction func closeButtonPressed(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: {})
    }
    
    
    func addTapMailGesture() {
        
        let tapMail = UITapGestureRecognizer(target: self, action: #selector(openMail))
        emailLabel.userInteractionEnabled = true
        emailLabel.addGestureRecognizer(tapMail)
    }
    
    
    func openMail() {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["ivano.rotondo@gmail.com"])
        mailComposerVC.setSubject("Hey! pedalaMI cyclist here:)")
        mailComposerVC.setMessageBody("Hello Ivano!\n\nI'm writing you because ...", isHTML: false)
        
        return mailComposerVC
    }
    
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: NSError) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}