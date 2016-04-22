//
//  Utilities.swift
//  pedalaMI
//
//  Created by Ivano Rotondo on 19/03/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static var messageFrame = UIView()
    static var activityIndicator = UIActivityIndicatorView()
    static var strLabel = UILabel()
    static var transparentFrame = UIView()
    
    static func loadingBarDisplayer(msg:String, indicator:Bool, view: UIView ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
//        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 100, y: view.frame.midY - 40 , width: 200, height: 80))
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 25, y: view.frame.midY - 25 , width: 50, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
//              loadingAnimationImageView.animateWithImage(named: "bike.gif")
//              loadingAnimationImageView.startAnimatingGIF()
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.tag = 2
            messageFrame.addSubview(activityIndicator)
        }
        //transparentFrame = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 10000))
        transparentFrame = UIView(frame: UIScreen.mainScreen().bounds)
        transparentFrame.backgroundColor = UIColor(white:90, alpha: 0.5)
        transparentFrame.tag = 1
        view.addSubview(transparentFrame)
        
        
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
        
        //add view constraints programmatically
        
        //          var newConstraint : NSLayoutConstraint = NSLayoutConstraint(item:self.messageFrame,attribute:.CenterX, relatedBy:.Equal, toItem:self.strLabel, attribute: .CenterX, multiplier: 1, constant: 0)
        //   messageFrame.addConstraint(newConstraint)
    }
    
//_____________________________________________//
//             BACKGROUND FUNCTION             //
//_________________INSTRUCTIONS________________//
    
//    A. To run a process in the background with a delay of 3 seconds:
//    
//    backgroundThread(3.0, background: {
//    // Your background function here
//    })
//    
//    
//    B. To run a process in the background then run a completion in the foreground:
//    
//    backgroundThread(background: {
//    // Your function here to run in the background
//    },
//    completion: {
//    // A function to run in the foreground when the background thread is complete
//    })
//    
//    
//    C. To delay by 3 seconds - note use of completion parameter without background parameter:
//    
//    backgroundThread(3.0, completion: {
//    // Your delayed function here to be run in the foreground
//    })
    
    static func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            if(background != nil){ background!(); }
            
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue()) {
                if(completion != nil){ completion!(); }
            }
        }
    }
    
    static func displayAlert(viewController: UIViewController, alertTextualDetails: AlertTextualDetails){
        
        let alertController = UIAlertController(title: alertTextualDetails.title, message:
            alertTextualDetails.message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: { action in
            Utilities.transparentFrame.removeFromSuperview()
            Utilities.activityIndicator.removeFromSuperview()
            Utilities.messageFrame.removeFromSuperview()
        }))
        dispatch_async(dispatch_get_main_queue(), {
            viewController.presentViewController(alertController, animated: true, completion: nil)
        })

    }
    
    struct AlertTextualDetails {
        var title = ""
        var message = ""
    }
    
    static func removeLoading() {
        //
        Utilities.transparentFrame.removeFromSuperview()
        Utilities.activityIndicator.removeFromSuperview()
        Utilities.messageFrame.removeFromSuperview()
    }

}
