//
//  TestCase.swift
//  MVVMLoginUITests
//
//  Created by Gaurav Rastogi on 9/18/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import XCTest

class TestCase: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    func tapBackBarButton() {
        if app.navigationBars.buttons.count == 0 {
            return
        }
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
}
