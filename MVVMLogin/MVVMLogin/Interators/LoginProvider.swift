//
//  LoginProvider.swift
//  AidATrade
//
//  Created by Gaurav Rastogi on 2/8/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import UIKit
import RxSwift

protocol LoginProviderProtocol:NSObjectProtocol {
    
    /**
     A method used to register a user into the local database
     
     - parameter credentials: An instance of UserCredetials used to store the email & password strings inputted from user
     
     - returns
     An instance of Single Sequence which contains UserCredentials or error <RepositoryError>
     */
    func register(with credentials:UserCredentials)->Single<UserCredentials>
    
    /**
     A method used to login a user into the system
     
     - parameter credentials: An instance of UserCredetials used to store the email & password strings inputted from user
     
     - returns
     An instance of Single Sequence which contains UserCredentials or error <RepositoryError>
     */
    func login(with credentials:UserCredentials)->Single<UserCredentials>
}

/**
 A mock class of Login Provider to be used only for Testing
 */
class LoginProviderMock: NSObject, LoginProviderProtocol{
    var registerIsCalled = false
    var loginIsCalled = false
    var logoutIsCalled = false
    
    func register(with credentials:UserCredentials) -> PrimitiveSequence<SingleTrait, UserCredentials> {
        self.registerIsCalled = true
        return Single.just(credentials)
    }
    
    func login(with credentials:UserCredentials) -> PrimitiveSequence<SingleTrait, UserCredentials> {
        self.loginIsCalled = true
        return Single.just(credentials)
    }
    
}

class LoginProvider: NSObject,LoginProviderProtocol {
    var repository:LoginRepositoryProtocol
    var disposeBag = DisposeBag()
    
    init(with repository:LoginRepositoryProtocol){
        self.repository = repository
    }
    
    func register(with credentials:UserCredentials) -> PrimitiveSequence<SingleTrait, UserCredentials> {
        return Single<UserCredentials>.create { observer in
            return self.repository
                .insert(credentials:credentials)
                .subscribe(onCompleted: {
                    return observer(.success(credentials))
                },
                           onError: { err in
                            return observer(.error(err))
                })
        }
    }
    
    func login(with credentials:UserCredentials) -> PrimitiveSequence<SingleTrait, UserCredentials> {
        return Single<UserCredentials>.create { observer in
            return self.repository
                .search(credentials:credentials)
                .subscribe(onCompleted: {
                    return observer(.success(credentials))
                },
                           onError: { err in
                    return observer(.error(err))
                })
        }
    }
}
