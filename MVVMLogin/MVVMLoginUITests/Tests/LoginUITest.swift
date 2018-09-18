//
//  LoginUITest.swift
//  MVVMLoginUITests
//
//  Created by Gaurav Rastogi on 9/18/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import XCTest

class LoginUITest: TestCase {
    
    var loginScreen : LoginScreen!
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        loginScreen = LoginScreen(app: app, testCase: self)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInvalidEmail() {        
        loginScreen.typeEmail(email: "invalid@email")
        loginScreen.typePassword(password: "ValidPassword@123")
        loginScreen.loginButton.tap()
        XCTAssertTrue(loginScreen.invalidEmailAlertExist)
    }
    
}
