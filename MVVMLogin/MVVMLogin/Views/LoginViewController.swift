//
//  LoginViewController.swift
//  AidATrade
//
//  Created by Gaurav Rastogi on 2/8/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var contactSupportBtn: UIButton!
    
    @IBOutlet weak var inputFeidlsContainerWidthConstraint: NSLayoutConstraint!
    private var screenWidth:CGFloat {
        get {
            return UIScreen.main.bounds.width
        }
    }
    
    private let disposeBag = DisposeBag()
    private var viewModel:LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
        setupViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        //Setting value for width constraint here and all subviews has been layout by now.
        if screenWidth == 320{
            self.inputFeidlsContainerWidthConstraint.constant = 286.0
        }
        else{
            self.inputFeidlsContainerWidthConstraint.constant = 220.0
        }
        
        //Setting background ground of login button for highlighted state
        self.loginBtn.setBackgroundColor(color: UIColor(rgb: 0x107387), forState: .highlighted, titleShadow: true)
        self.loginBtn.roundedButton()
        
        //Setting background ground of create button for highlighted state
        self.createAccountBtn.setBackgroundColor(color: UIColor(rgb: 0x188594), forState: .highlighted, titleShadow: true)
        self.createAccountBtn.roundedButton()
    }
    
    /**
     A private method used to setup various UI element in Controller
     */
    private func initialSetup(){
        self.emailTextField.setPlaceholderColor((UIColor(rgb: 0xFFFFFF)))
        self.emailTextField.setTextColor((UIColor(rgb: 0xFFFFFF)), shadow: true)
        
        self.passwordTextField.setPlaceholderColor((UIColor(rgb: 0xFFFFFF)))
        self.passwordTextField.setTextColor((UIColor(rgb: 0xFFFFFF)), shadow: true)
    }
    
    /**
     A private method used to setup/bind various events of ViewModel to the relevant element in Controller
     */
    private func setupViewModel(){
        self.viewModel = LoginViewModel.create()
        
        self.emailTextField.rx.text
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        self.passwordTextField.rx.text
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        self.emailTextField.rx
            .controlEvent(.editingDidBegin)
            .bind { [unowned self] in
                self.emailTextField.setPlaceholderColor(UIColor(rgb: 0xCCF2FF,alpha: 0.6))
            }
            .disposed(by: disposeBag)
        
        self.emailTextField.rx
            .controlEvent(.editingDidEnd)
            .bind { [unowned self] in
                self.emailTextField.setPlaceholderColor(UIColor(rgb: 0xFFFFFF))
            }
            .disposed(by: disposeBag)
        
        self.emailTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .bind { [unowned self] in
                self.passwordTextField.becomeFirstResponder()
            }
            .disposed(by: disposeBag)
        
        self.passwordTextField.rx
            .controlEvent(.editingDidBegin)
            .bind { [unowned self] in
                self.passwordTextField.setPlaceholderColor(UIColor(rgb: 0xCCF2FF,alpha: 0.6))
            }
            .disposed(by: disposeBag)
        
        self.passwordTextField.rx
            .controlEvent(.editingDidEnd)
            .bind { [unowned self] in
                self.passwordTextField.setPlaceholderColor(UIColor(rgb: 0xFFFFFF))
            }
            .disposed(by: disposeBag)
        
        self.passwordTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .bind { [unowned self] in
                self.loginBtn.sendActions(for: .touchUpInside)
            }
            .disposed(by: disposeBag)
        
        self.loginBtn.rx.tap
            .withLatestFrom(viewModel.credentials)
            .flatMapLatest { [unowned self] credentials  in
                self.viewModel
                    .login(with: credentials)
                    .asObservable()
                    .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
                    .catchError({[unowned self] error -> Observable<UserCredentials> in
                        DispatchQueue.main.async{
                            self.showAlert("Failure", error.localizedDescription)
                        }
                        return Observable<UserCredentials>.empty()
                    })
            }
            .observeOn(MainScheduler.instance)
            .subscribe({[unowned self] event in
                switch event{
                case .next(let credentials):
                    DispatchQueue.main.async{
                        self.showAlert(credentials.email, "Successfully logged in")
                    }
                    break
                case .completed: break
                case .error: break
                }
            })
            .disposed(by: disposeBag)
        
        self.createAccountBtn.rx.tap
            .withLatestFrom(viewModel.credentials)
            .flatMapLatest { [unowned self] credentials  in
                self.viewModel
                    .createAccount(with: credentials)
                    .asObservable()
                    .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
                    .catchError({[unowned self] error -> Observable<UserCredentials> in
                        DispatchQueue.main.async{
                            self.showAlert("Failure", error.localizedDescription)
                        }
                        return Observable<UserCredentials>.empty()
                    })
            }
            .observeOn(MainScheduler.instance)
            .subscribe({[unowned self] event in
                switch event{
                case .next(let credentials):
                    DispatchQueue.main.async{
                        self.showAlert(credentials.email, "Successfully registered")
                    }
                    break
                case .completed:break
                case .error:break
                }
            })
            .disposed(by: disposeBag)
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
    }
    
    /**
     A private method used to present Alert onto current controller.
     */
    private func showAlert(_ title:String, _ message:String){
        var alert:UIAlertController
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
