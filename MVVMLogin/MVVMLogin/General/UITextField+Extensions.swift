//
//  UITextField+Extensions.swift
//  AidATrade
//
//  Created by Gaurav Rastogi on 2/19/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setPlaceholderColor(_ color:UIColor){
        if let placeholder = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string:placeholder,
                                                                      attributes: [NSAttributedStringKey.foregroundColor: color])
        }
    }
    
    func setTextColor(_ color:UIColor, shadow:Bool){
        self.textColor = color
        if shadow{
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0.33, height: 0.33)
            self.layer.shadowOpacity = 0.5
            self.layer.shadowRadius = 0.33
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
}
