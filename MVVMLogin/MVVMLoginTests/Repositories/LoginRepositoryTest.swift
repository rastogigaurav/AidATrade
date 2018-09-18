//
//  LoginRepositoryTest.swift
//  AidATradeTests
//
//  Created by Gaurav Rastogi on 2/7/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import XCTest
import RxSwift

@testable import MVVMLogin

class LoginRepositoryTest: XCTestCase {
    
    private var repository: LoginRepository!
    private var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        disposeBag = DisposeBag()
        repository = LoginRepository()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDBInsertionSuccessful(){
        let expectation = self.expectation(description: "Expecting to insert user info into local database successfully")
    
        repository
            .insert(credentials: UserCredentials.random())
            .subscribe(onCompleted: {
                expectation.fulfill()
            },
                       onError: { error in
                        XCTFail("Completed with an error: \(error.localizedDescription)")
            })
        .disposed(by: disposeBag)

        // wait for expectations
        waitForExpectations(timeout: 2) { (error) in
            if let _ = error {
                XCTFail("Failed to insert user info into local database")
            }
        }
    }
    
    func testLoginSuccessful() {
        let expectation = self.expectation(description: "Expecting to login user successfully")
        
        repository.search(credentials: UserCredentials.random())
            .subscribe(onCompleted: {
                expectation.fulfill()
            },
                       onError: { error in
                        XCTFail("Completed with an error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
        
        //wait for expectation
        waitForExpectations(timeout: 2){ (error) in
            if let _ = error{
                XCTFail("Failed to login user successfully")
            }
        }
    }
}
