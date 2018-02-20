//
//  LoginViewModel.swift
//  AidATrade
//
//  Created by Gaurav Rastogi on 2/8/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import RxSwift
import RxSwiftExt

protocol LoginViewModelProtocol {
    /**
     An observable sequence which emits all the inputed values of email from user and is also binded to the View's Email TextField
     */
    var email: Variable<String?> { get }
    
    /**
     An observable sequence which emits all the inputed values of password from user and is also binded to the View's Password TextField
     */
    var password: Variable<String?> { get }
    
    /**
     An observable sequence which emits combined email & password sequences in the form of UserCredentials
     */
    var credentials:Observable<UserCredentials> { get }
    
    /**
     A method used to sign-in/login of inputted user with the help of login provider
     
     - parameter credentials: An instance of UserCredetials used to store the email & password strings inputted from user
     
     - returns
     An instance of Single Sequence which contains UserCredentials or error <RepositoryError>
     */
    func login(with credentials:UserCredentials)->Single<UserCredentials>
    
    /**
     A method used to sign-up/register/create account of inputted with the help of login provider
     
     - parameter credentials: An instance of UserCredetials used to store the email & password strings inputted from user
     
     - returns
     An instance of Single Sequence which contains UserCredentials or error <RepositoryError>
     */
    func createAccount(with credentials:UserCredentials)->Single<UserCredentials>
}

class LoginViewModel: NSObject,LoginViewModelProtocol {
    private let disposeBag = DisposeBag()
    
    let email = Variable<String?>(nil)
    let password = Variable<String?>(nil)
    
    var credentials: Observable<UserCredentials>
    
    var provider:LoginProviderProtocol
    
    init(with loginProvider:LoginProviderProtocol) {
        self.provider = loginProvider
        let email = self.email.asObservable().unwrap().map { $0.lowercased() }
        let password = self.password.asObservable().unwrap()
        
        let emailAndPassword = Observable.combineLatest(email, password) { ($0, $1) }
        self.credentials = emailAndPassword
                            .asObservable()
                            .map {
                                UserCredentials(email: $0, password: $1)
                            }
    }
    
    func login(with credentials:UserCredentials) -> PrimitiveSequence<SingleTrait, UserCredentials> {
        return self.provider
                    .login(with:credentials)
    }
    
    func createAccount(with credentials:UserCredentials) -> PrimitiveSequence<SingleTrait, UserCredentials> {
        return self.provider
                    .register(with:credentials)
    }
}

extension LoginViewModel{
    /**
     A static method used to instantiate `LoginViewModel` and inject dependencies into it
     */
    static func create() ->LoginViewModel{
        let repository = LoginRepository()
        let provider = LoginProvider(with: repository)
        return LoginViewModel(with: provider)
    }
}
