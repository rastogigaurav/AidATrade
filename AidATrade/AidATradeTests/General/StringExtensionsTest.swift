//
//  StringExtensionsTest.swift
//  AidATradeTests
//
//  Created by Gaurav Rastogi on 2/20/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import XCTest

@testable import AidATrade

class StringExtensionsTest: XCTestCase {
    
    func testIsValidEmail(){
        let validEmail = "first.last@gmail.com"
        
        let invalidEmail = "first.last.com"
        
        XCTAssertTrue(validEmail.isValidEmail())
        XCTAssertFalse(invalidEmail.isValidEmail())
    }
    
    func testIsValidPassword(){
        let validPassword = "Passw0rd"
        
        let invalidPassword = "password"
        
        XCTAssertTrue(validPassword.isValidPassword())
        XCTAssertFalse(invalidPassword.isValidPassword())
    }
    
}
