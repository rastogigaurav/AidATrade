//
//  LoginRepository.swift
//  AidATrade
//
//  Created by Gaurav Rastogi on 2/7/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import UIKit
import RxSwift

enum RepositoryError: LocalizedError,Error {
    case emailEmpty
    case passwordEmpty
    case invalidEmail
    case invalidPassword
    case userAlreadyExist
    case userNotRegistered
    case unableToRegister
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .emailEmpty:
            return "Email can't be empty"
        case .passwordEmpty:
            return "Password can't be empty"
        case .invalidEmail:
            return "Invalid Email"
        case .invalidPassword:
            return "Invalid Password"
        case .userAlreadyExist:
            return "User already registered"
        case .userNotRegistered:
            return "Check your email & password"
        case .unableToRegister:
            return "Registration Failure"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

/**
 Struct to hold the credentials inputed into the email & password feilds
 */
struct UserCredentials {
    let email:String
    let password:String
    
    /**
     A method used to check validity of email and password and throw error <RepositoryError> in case of discrepency
     */
    func validate() throws {
        guard email.count > 0 else { throw RepositoryError.emailEmpty }
        guard email.isValidEmail() else { throw RepositoryError.invalidEmail }
        guard password.count > 0 else { throw RepositoryError.passwordEmpty }
        guard password.isValidPassword() else { throw RepositoryError.invalidPassword }
    }
}

extension UserCredentials {
    
    /**
     A method to generate random credential and is used for testing of various elements
     */
    static func random() -> UserCredentials{
        return UserCredentials(email: "first.last@gmail.com", password: "Passw0rd")
    }
}

protocol LoginRepositoryProtocol:NSObjectProtocol {
    
    /**
     A method used to interaxt with Database Manager and insert the relevant record <User> into the local database.
     - parameter credentials: An instance of UserCrdentials which contains inputted values of email & password from user.
     - returns
     An Completable Sequence
     */
    func insert(credentials:UserCredentials)->Completable
    
    /**
     A method used to interaxt with Database Manager and search the desired record <User> into the local database.
     - parameter credentials: An instance of UserCrdentials which contains inputted values of email & password from user.
     - returns
     An Completable Sequence
     */
    func search(credentials:UserCredentials)->Completable
}

/**
 A mock class of Login Repository to be used only for Testing
 */
class LoginRepositoryMock: NSObject, LoginRepositoryProtocol{
    var insertIsCalled = false
    var searchIsCalled = false
    
    func insert(credentials:UserCredentials) -> Completable {
        self.insertIsCalled = true
        return Completable.empty()
    }
    
    func search(credentials:UserCredentials) -> Completable {
        self.searchIsCalled = true
        return Completable.empty()
    }
}

class LoginRepository: NSObject,LoginRepositoryProtocol {
    func insert(credentials:UserCredentials) -> Completable {
        do {
            try credentials.validate()
        }
        catch{
            return Completable.error(error)
        }
        
        if DBManager.sharedInstance.emailAlreadyRegistered(user: User(email: credentials.email, password: credentials.password)) == true{
            return Completable.error(RepositoryError.userAlreadyExist)
        }
        
        if DBManager.sharedInstance.insert(user: User(email: credentials.email, password: credentials.password)) == true{
            return Completable.empty()
        }
        
        return Completable.error(RepositoryError.unknown)
    }
    
    func search(credentials:UserCredentials) -> Completable {
        do {
            try credentials.validate()
        }
        catch{
            return Completable.error(error)
        }
        
        if DBManager.sharedInstance.isUserInDatabase(user: User(email: credentials.email, password: credentials.password)) == true{
            return Completable.empty()
        }
        
        return Completable.error(RepositoryError.userNotRegistered)
    }
}
