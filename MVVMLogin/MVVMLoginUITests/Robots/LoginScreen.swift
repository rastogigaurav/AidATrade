//
//  LoginScreen.swift
//  MVVMLoginUITests
//
//  Created by Gaurav Rastogi on 9/18/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import Foundation
import XCTest

class LoginScreen : AppScreen{
    var loginButton : XCUIElement{
        return app.buttons.element(matching: .button, identifier: "loginButton")
    }
    
    var createAccountButton : XCUIElement{
        return app.buttons.element(matching: .button, identifier: "createButton")
    }
    
    var invalidEmailAlertExist : Bool{
        let element = app.alerts["Failure"]
        if element.exists{
            element.buttons["OK"].tap()
            return true
        }
        return false
    }
    
    func typeEmail(email: String) {
        //Tapping on the text field
        let emailTextField = app.textFields.element(matching: .textField, identifier: "emailTextField")
        emailTextField.tap()
        app.typeText(email)
    }
    
    func typePassword(password: String) {
        //Tapping on the text field
        let passwordTextField = app.secureTextFields.element(matching: .secureTextField, identifier: "passwordTextField")
        passwordTextField.tap()
        app.typeText(password)
    }
}
