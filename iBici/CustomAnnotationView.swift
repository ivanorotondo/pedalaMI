//
//  CustomAnnotationView.swift
//  pedalaMI
//
//  Created by Ivo on 06/12/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//

import Foundation
import Mapbox


class CustomAnnotationView: MGLAnnotationView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scalesWithViewingDistance = false
        
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.whiteColor().CGColor
        
        //working
        //        let myImage = UIImage(named: "pinTapWater")?.CGImage
        //
        //        layer.contents = myImage
        //        layer.contentsGravity = kCAGravityResizeAspect
        
        let label = CATextLayer()
        let textLayer = CATextLayer(layer: layer)
        textLayer.fontSize = 16
        textLayer.string = "\(tag)"
        
        if textLayer.string?.length == 1 {
            textLayer.frame = CGRectMake(0, 5, 30, 30)
        }
        if textLayer.string?.length == 2 {
            textLayer.frame = CGRectMake(0, 5, 30, 30)
        }
        
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.foregroundColor = UIColor.whiteColor().CGColor
        textLayer.hidden = false
        textLayer.masksToBounds = true
        
        layer.addSublayer(textLayer)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? frame.width / 4 : 2
        layer.addAnimation(animation, forKey: "borderWidth")
    }
}
  