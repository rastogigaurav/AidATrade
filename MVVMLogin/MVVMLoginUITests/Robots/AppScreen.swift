//
//  AppScreen.swift
//  MVVMLoginUITests
//
//  Created by Gaurav Rastogi on 9/18/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import Foundation
import XCTest

class AppScreen {
    let app: XCUIApplication
    let testCase: TestCase
    
    init(app: XCUIApplication, testCase: TestCase) {
        self.app = app
        self.testCase = testCase
    }
    
    @discardableResult func andDo<T: AppScreen>(block: (T) -> Void) -> Self {
        block(self as! T)
        return self
    }
    
    var isKeyboardShowing: Bool {
        return app.keyboards.count >= 0
    }
    
}
