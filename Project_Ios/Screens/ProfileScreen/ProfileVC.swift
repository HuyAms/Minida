//
//  ProfileVC.swift
//  Project_Ios
//
//  Created by iosdev on 13.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

protocol ProfileViewProtocol: class {
    
    func onLogoutSuccess()
    
}

class ProfileVC: UIViewController, ProfileViewProtocol  {
    
    //MARK: Properties
    var presenter: ProfilePresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ProfilePresenter(view: self)
        
        // Do any additional setup after loading the view.
    }

    @IBAction func logOutBtnWasPressed(_ sender: Any) {
        
        let alertViewController = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.presenter?.logout()
        }
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertViewController.addAction(okAction)
        alertViewController.addAction(cancleAction)
        present(alertViewController, animated: true)
    }
    
    
    func onLogoutSuccess() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let authVC = storyBoard.instantiateViewController(withIdentifier: AppStoryBoard.authVC.identifier)
        appDelegate.window?.rootViewController = authVC
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
}
