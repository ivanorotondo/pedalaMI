//
//  Utilities.swift
//  pedalaMI
//
//  Created by Ivano Rotondo on 19/03/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import UIKit
import Gifu

class Utilities {
    
    static var messageFrame = UIView()
    static var activityIndicator = UIActivityIndicatorView()
    static var strLabel = UILabel()
    static var transparentFrame = UIView()
    
    static var loadingAnimationImageView = AnimatableImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 80))

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
}
