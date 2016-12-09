//
//  ContainerViewController.swift
//  
//
//  Created by Ivo on 06/12/16.
//
//

import Foundation
import SlideMenuControllerSwift


class ContainerVC: SlideMenuController {
    

    override func awakeFromNib() {
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        SlideMenuOptions.rightViewWidth = 250
        SlideMenuOptions.panFromBezel = false
        SlideMenuOptions.rightPanFromBezel = false
        
        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MapVC") {
            self.mainViewController = controller
        }
        
        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MenuViewController") {
            (controller as! MenuViewController).mapVC = self.mainViewController as! MapVC
            (controller as! MenuViewController).containerVC = self
            self.rightViewController = controller
        }
        super.awakeFromNib()
    }
}