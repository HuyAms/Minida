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
    @IBOutlet weak var authSwitchBtn: UIButton!
    @IBOutlet weak var idTouchButton: UIButton!
    
    @IBOutlet weak var changeAccountBtn: UIButton!
    @IBOutlet weak var emailStack: UIStackView!
    @IBOutlet weak var phoneNumberStack: UIStackView!
    @IBOutlet weak var performSignUpBtn: UIButton!
    @IBOutlet weak var authFooterLbl: UILabel!
    
    //MARK: Properties
    var presenter: AuthPresenterProtocol?
    var isSignIn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AuthPresenter(view: self)
        delegateTextField()
        presenter?.checkToken()
        presenter?.checkBiometricAuthAvailable()
        
        let tapGusture = UITapGestureRecognizer(target: self, action: #selector(AuthVC.dismissKeyboard))
        view.addGestureRecognizer(tapGusture)
    }
    
    //MARK: Actions
    @IBAction func idBtnWasPressed(_ sender: Any) {
        presenter?.performIdVerificaiton()
    }
    

    @IBAction func authSwitchBtnWasPressed(_ sender: Any) {
        if isSignIn {
           //Register clicked
            isSignIn = false
            authFooterLbl.text = "Already have an account?"
            authStatusLbl.text = "SIGN UP"
            emailStack.isHidden = false
            phoneNumberStack.isHidden = false
            hideIdBtn()
            hideChangeAccountBtn()
            usernameTextField.text = ""
            passwordTextField.text = ""
            authSwitchBtn.setTitle("Sign In", for: .normal)
        } else {
             //Sign in clicked
            isSignIn = true
            authFooterLbl.text = "Don't have an account?"
            authStatusLbl.text = "SIGN IN"
            emailStack.isHidden = true
            phoneNumberStack.isHidden = true
            presenter?.checkBiometricAuthAvailable()
            authSwitchBtn.setTitle("Register", for: .normal)
            presenter?.checkToken()
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
        idTouchButton.isHidden = true
    }
    
    func showIdBtn() {
        idTouchButton.isHidden = false
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
        changeAccountBtn.isHidden = false
    }
    
    func hideChangeAccountBtn() {
        changeAccountBtn.isHidden = true
    }
    
    func goToMainVC() {
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
