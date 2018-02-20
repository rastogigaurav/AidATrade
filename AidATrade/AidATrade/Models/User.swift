//
//  User.swift
//  AidATrade
//
//  Created by Gaurav Rastogi on 2/7/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import UIKit

/**
 A model class to store and hold various properties of User.
 */
class User: NSObject {
    
    /// The email address of the user
    var email: String!
    
    /// The password of the user
    var password: String!
    
    convenience init(email: String, password: String) {
        self.init()
        self.email = email
        self.password = password
    }
}



