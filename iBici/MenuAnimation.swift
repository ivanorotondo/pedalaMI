//
//  MenuAnimation.swift
//  pedalaMI
//
//  Created by Ivano Rotondo on 14/04/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import UIKit

extension MapViewController {
    
    func animateMenuController(sender: UITapGestureRecognizer) {
        
        //self.slideMenuController()?.openLeft()
        let refreshButtonInitialOriginY = CGFloat(settingsButton.frame.origin.y + 48.0)
        let refreshButtonFinalOriginY = CGFloat(tapWaterButton.frame.origin.y + 44.0)
        
        if menuIsShowed == false {
            showMenu(refreshButtonInitialOriginY, refreshButtonFinalOriginY: refreshButtonFinalOriginY)
            menuIsShowed = true
        } else {
            hideMenu(refreshButtonInitialOriginY, refreshButtonFinalOriginY: refreshButtonFinalOriginY)
            menuIsShowed = false
        }
        
        
    }
    
    func showMenu(refreshButtonInitialOriginY: CGFloat, refreshButtonFinalOriginY: CGFloat) {
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.bikePathsButton.alpha = 1
            
            self.bikePathsButton.userInteractionEnabled = true
            
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.paveButton.alpha = 1
            self.bikeStationsButton.alpha = 1
            self.tapWaterButton.alpha = 1
            
            self.paveButton.userInteractionEnabled = true
            self.bikeStationsButton.userInteractionEnabled = true
            self.tapWaterButton.userInteractionEnabled = true
            
            self.refreshButton.frame.origin.y += refreshButtonFinalOriginY - refreshButtonInitialOriginY
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    func hideMenu(refreshButtonInitialOriginY: CGFloat, refreshButtonFinalOriginY: CGFloat) {
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.paveButton.alpha = 0
            self.bikeStationsButton.alpha = 0
            self.tapWaterButton.alpha = 0
            
            self.paveButton.userInteractionEnabled = false
            self.bikeStationsButton.userInteractionEnabled = false
            self.tapWaterButton.userInteractionEnabled = false
            
            self.view.layoutIfNeeded()
            }, completion: nil)
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.bikePathsButton.alpha = 0
            
            self.bikePathsButton.userInteractionEnabled = false
            
            self.refreshButton.frame.origin.y -= refreshButtonFinalOriginY - refreshButtonInitialOriginY
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
}