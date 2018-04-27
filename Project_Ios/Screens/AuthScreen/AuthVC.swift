//
//  AuthVC.swift
//  Project_Ios
//
//  Created by iosdev on 11.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit


protocol AuthViewProtocol: class {
    
    func showLoading()
    
    func hideLoading()
    
    func onShowError(error: AppError)
    
    func onSuccess()
    
    func onVerifyIdSuccess()
    
    func onVerifyIdError(error: String)
    
    func setIdBtnAsFaceId()
    
    func setIdBtnAsTouchId()
    
    func hideIdBtn()
    
    func showIdBtn()
    
    func setUserName(userName: String)
    
    func onChangeAccountSuccess()
    
    func showChangeAccountBtn()
    
    func hideChangeAccountBtn()
}

class AuthVC: UIViewController, AuthViewProtocol {

    //MARK: Outlet
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phonenumberTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var authStatusLbl: UILabel!
    
    @IBOutlet weak var idTouchButton: UIButton!
    @IBOutlet weak var changeAccountBtn: UIButton!
    @IBOutlet weak var performSignUpBtn: UIButton!
    @IBOutlet weak var authSwitchBtn: UIButton!
    
    @IBOutlet weak var passwordStack: UIStackView!
    @IBOutlet weak var usernameStack: UIStackView!
    @IBOutlet weak var emailStack: UIStackView!
    @IBOutlet weak var phoneNumberStack: UIStackView!
    
    
    //MARK: Properties
    var presenter: AuthPresenterProtocol?
    var isSignIn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = AuthPresenter(view: self)
        delegateTextField()
        presenter?.checkToken()
        presenter?.checkBiometricAuthAvailable()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AuthVC.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        animateAuthForm()
    }
    
    func animateAuthForm() {
        //Initial
        usernameStack.center.x -= view.bounds.width
        passwordStack.center.x -= view.bounds.width
        
        authStatusLbl.center.y += 30.0
        authStatusLbl.alpha = 0.0
        
        //Animate
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
            self.usernameStack.center.x += self.view.bounds.width
        }, completion: nil)
        
        UIView.animate(withDuration: 0.7, delay: 0.3, options: .curveEaseOut, animations: {
            self.passwordStack.center.x += self.view.bounds.width
        }, completion: nil)
        
        UIView.animate(withDuration: 0.7, delay: 0.8, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.authStatusLbl.center.y -= 30.0
            self.authStatusLbl.alpha = 1.0
        }, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func idBtnWasPressed(_ sender: Any) {
        presenter?.performIdVerificaiton()
    }
    

    @IBAction func authSwitchBtnWasPressed(_ sender: Any) {
        if isSignIn {
           //Register clicked
            isSignIn = false
            authStatusLbl.text = "SIGN UP"
            
            hideIdBtn()
            hideChangeAccountBtn()
            usernameTextField.text = ""
            passwordTextField.text = ""
            authSwitchBtn.setTitle("Already have an account?", for: .normal)
            
            UIView.transition(with: self.emailStack, duration: 0.5, options: .transitionCurlDown, animations: {
                self.emailStack.isHidden = false
            }, completion: nil)
            
            UIView.transition(with: self.phoneNumberStack, duration: 0.5, options: .transitionCurlDown, animations: {
                self.phoneNumberStack.isHidden = false
            }, completion: nil)
            
        } else {
             //Sign in clicked
            isSignIn = true
            authStatusLbl.text = "SIGN IN"
            authSwitchBtn.setTitle("Don't have an account?", for: .normal)
            presenter?.checkToken()
            self.presenter?.checkBiometricAuthAvailable()
            
            UIView.transition(with: self.emailStack, duration: 0.5, options: .transitionCurlUp, animations: {
                self.emailStack.isHidden = true
            }, completion: nil)
            
            UIView.transition(with: self.phoneNumberStack, duration: 0.5, options: .transitionCurlUp, animations: {
                self.phoneNumberStack.isHidden = true
            }, completion: nil)
        }
    }
    
    @IBAction func performSignUp(_ sender: Any) {
        if (isSignIn) {
            let username = usernameTextField.text ?? ""
            let password = passwordTextField.text ?? ""
            presenter?.performLogin(userName: username , password: password)
        } else {
            let username = usernameTextField.text ?? ""
            let password = passwordTextField.text ?? ""
            let email = emailTextField.text ?? ""
            let phoneNumber = phonenumberTextField.text ?? ""
            presenter?.performRegister(userName: username, password: password, email: email, phoneNumber: phoneNumber)
        }
    }
    
    @IBAction func changeAccountBtnWasPressed(_ sender: Any) {
        presenter?.changeAccount()
    }
    
    
    //MARK: Protocols
    func onShowError(error: AppError) {
        errorLabel.isHidden = false
        errorLabel.text = error.description
        errorLabel.shake()
    }
    
    func onSuccess() {
       goToMainVC()
    }
    
    func showLoading() {
        showLoadingIndicator()
    }
    
    func hideLoading() {
        hideLoadingIndicator()
    }
    
    func hideIdBtn() {
        UIView.transition(with: self.idTouchButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.idTouchButton.isHidden = true
        }, completion: nil)
        
    }
    
    func showIdBtn() {
        UIView.transition(with: self.idTouchButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.idTouchButton.isHidden = false
        }, completion: nil)
    }
    
    func setIdBtnAsFaceId() {
        idTouchButton.setImage(UIImage.getFaceIdImage(),  for: .normal)
    }
    
    func setIdBtnAsTouchId() {
        idTouchButton.setImage(UIImage.getTouchIdImage(),  for: .normal)
    }
    
    func onVerifyIdSuccess() {
        goToMainVC()
    }
    
    func onVerifyIdError(error: String) {
        DispatchQueue.main.async {
            self.errorLabel.isHidden = false
            self.errorLabel.text = error
        }
    }
    
    func setUserName(userName: String) {
        usernameTextField.text = userName
        //changeAccountBtn.isHidden = false
        
    }
    
    func onChangeAccountSuccess() {
        presenter?.checkBiometricAuthAvailable()
        usernameTextField.text = ""
    }
    
    func delegateTextField() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        phonenumberTextField.delegate = self
    }
    
    func showChangeAccountBtn() {
        UIView.transition(with: self.changeAccountBtn, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.changeAccountBtn.isHidden = false
        }, completion: nil)
    }
    
    func hideChangeAccountBtn() {
        UIView.transition(with: self.changeAccountBtn, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.changeAccountBtn.isHidden = true
        }, completion: nil)
    }
    
    func goToMainVC() {
        UIApplication.shared.statusBarStyle = .lightContent
        guard let mainVC = storyboard?.instantiateViewController(withIdentifier: AppStoryBoard.mainVC.identifier) else {return}
        present(mainVC, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AuthVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorLabel.text = ""
    }
}
