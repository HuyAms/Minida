//
//  LoginVC.swift
//  Project_Ios
//
//  Created by Dat Truong on 04/04/2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpWasTapped(_ sender: UIButton) {
        let registerVC = storyboard?.instantiateViewController(withIdentifier: StoryBoardID.registerVC.id)
        presentWithTransition(registerVC!, animated: false, completion: nil)
    }
    
   

}
