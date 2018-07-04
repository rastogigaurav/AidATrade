//
//  UIButton+Extensions.swift
//  AidATrade
//
//  Created by Gaurav Rastogi on 2/9/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import UIKit

extension UIButton {
    func setBackgroundColor(color: UIColor, forState state: UIControlState, titleShadow shadow:Bool) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: state)
        shadow ? addTitleShadow():nil
    }
    
    func roundedButton(){
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: [.allCorners],
                                     cornerRadii:CGSize(width: 4.0, height: 4.0))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
        
    }
    
    func addTitleShadow(){
        self.titleLabel?.layer.shadowRadius = 0.33
        self.titleLabel?.layer.shadowColor = UIColor.black.cgColor
        self.titleLabel?.layer.shadowOffset = CGSize(width: 0.33, height: 0.33)
        self.titleLabel?.layer.shadowOpacity = 0.5
        self.titleLabel?.layer.masksToBounds = false
    }
}

