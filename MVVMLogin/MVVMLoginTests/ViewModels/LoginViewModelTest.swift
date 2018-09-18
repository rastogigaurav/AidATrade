//
//  LoginViewModelTest.swift
//  AidATradeTests
//
//  Created by Gaurav Rastogi on 2/10/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import XCTest
import RxSwift

@testable import MVVMLogin

class LoginViewModelTest: XCTestCase {
    
    var provider:LoginProviderMock!
    var viewModel:LoginViewModel!
    var disposeBag:DisposeBag!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.provider = LoginProviderMock()
        self.viewModel = LoginViewModel(with: self.provider)
        self.disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin(){
        let expecctation = self.expectation(description: "Expecting the user to get logged in successfully")
        
        self.viewModel
            .login(with: UserCredentials.random())
            .subscribe({ _ in
                XCTAssertTrue(self.provider.loginIsCalled)
                expecctation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 2.0) { (error) in
            if let _ = error {
                XCTFail("Failed to verify and logged in the user")
            }
        }
    }
    
    func testCreateAccount(){
        let expectation = self.expectation(description: "Expecting the user to get register into the system")
        self.viewModel
            .createAccount(with: UserCredentials.random())
            .subscribe({_ in
                XCTAssertTrue((self.provider.registerIsCalled))
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 2.0) { (error) in
            if let _ = error {
                XCTFail("Failed to regster user into the local database")
            }
        }
    }
}
