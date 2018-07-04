//
//  UserTest.swift
//  AidATradeTests
//
//  Created by Gaurav Rastogi on 2/12/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import XCTest

@testable import AidATrade

class UserTest: XCTestCase {
    
    private let user = User(email: UserCredentials.random().email, password: UserCredentials.random().password)
    
    func testConvenienceInitializer() {
        XCTAssertEqual(user.email, "first.last@gmail.com")
        XCTAssertEqual(user.password, "Passw0rd")
    }
}
