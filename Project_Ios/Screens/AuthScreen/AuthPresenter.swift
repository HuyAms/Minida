//
//  AuthPresenter.swift
//  Project_Ios
//
//  Created by iosdev on 11.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

//LOGIC
protocol AuthPresenterProtocol {
    
    func performLogin(userName: String, password: String)
    
    func performRegister(userName: String, password: String, email: String, phoneNumber: String)
    
}

class AuthPresenter: AuthPresenterProtocol {
    
    
    weak var view: AuthViewProtocol? //remember we need weak to prevent memory leak
    var authService: AuthServiceProtocol = AuthService()
    
    //constructor in Java
    init(view: AuthViewProtocol) {
        self.view = view
    }
    
    func performLogin(userName: String, password: String) {
        view?.showLoading()
        
        if userName.isEmpty || password.isEmpty {
            view?.onShowError(error: .emptyField)
            view?.hideLoading()
        } else {
            //perform login here
            authService.login(username: userName, password: password, completion: {  response in
                switch response {
                case .success(let response):
                    //do sth with the response
                    //Save the token in defaultUsers
                    print("This is the response: \(response)")
                    self.view?.onSuccess()
                    self.view?.hideLoading()
                case .error(let error):
                    self.view?.onShowError(error: error)
                    self.view?.hideLoading() //put self here is not the right way
                }
            })
            
        }
    }
    
    func performRegister(userName: String, password: String, email: String, phoneNumber: String) {
        view?.showLoading()
        
        if userName.isEmpty || password.isEmpty || email.isEmpty || phoneNumber.isEmpty {
            view?.onShowError(error: .emptyField)
            view?.hideLoading()
        } else {
            // perform register here
            authService.register(username: userName, password: password, email: email, phoneNumber: phoneNumber, completion: {  response in
                switch response {
                case .success(let response):
                    //do sth with the response
                    //Save the token in defaultUsers
                    print("This is the response: \(response)")
                    self.view?.onSuccess()
                    self.view?.hideLoading()
                case .error(let error):
                    print(error)
                    self.view?.onShowError(error: error)
                    self.view?.hideLoading() //put self here is not the right way
                }
            })
        }
    }
}
