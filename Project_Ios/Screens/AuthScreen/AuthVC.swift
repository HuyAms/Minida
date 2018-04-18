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
}

class AuthVC: UIViewController, AuthViewProtocol {

    //MARK: Outlet
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phonenumberTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var idTouchButton: UIButton!
    
    @IBOutlet weak var emailStack: UIStackView!
    @IBOutlet weak var phoneNumberStack: UIStackView!
    @IBOutlet weak var performSignUpBtn: UIButton!
    @IBOutlet weak var changeAccountBtn: UIButton!
    
    //MARK: Properties
    var presenter: AuthPresenterProtocol?
    var isSignIn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AuthPresenter(view: self)
        delegateTextField()
        presenter?.checkBiometricAuthAvailable()
        presenter?.checkToken()
    }
    
    //MARK: Actions
    @IBAction func idBtnWasPressed(_ sender: Any) {
        presenter?.performIdVerificaiton()
    }
    
    
    @IBAction func signUpBtnWasPressed(_ sender: Any) {
        isSignIn = false
        emailStack.isHidden = false
        phoneNumberStack.isHidden = false
        hideIdBtn()
        performSignUpBtn.setTitle("Sign Up", for: .normal)
    }
    
    @IBAction func signInBtnWasPressed(_ sender: Any) {
        isSignIn = true
        emailStack.isHidden = true
        phoneNumberStack.isHidden = true
        presenter?.checkBiometricAuthAvailable()
        performSignUpBtn.setTitle("Sign In", for: .normal)
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
        errorLabel.text = error.description
    }
    
    func onSuccess() {
       goToTabVC()
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
        goToTabVC()
    }
    
    func onVerifyIdError(error: String) {
        print("verify by id failed: \(error)")
    }
    
    func setUserName(userName: String) {
        usernameTextField.text = userName
        changeAccountBtn.isHidden = false
        
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
    
    func goToTabVC() {
        guard let tabBarVC = storyboard?.instantiateViewController(withIdentifier: AppStoryBoard.tabBarVC.identifier) else {return}
        present(tabBarVC, animated: true, completion: nil)
    }

}

extension AuthVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorLabel.text = ""
    }
}
