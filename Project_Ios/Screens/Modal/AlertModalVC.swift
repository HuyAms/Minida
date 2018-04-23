//
//  SuccessModalVC.swift
//  Project_Ios
//
//  Created by iosdev on 23.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

class AlertModalVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var modalBackGround: UIView!
    
    var modalTitle: String?
    var modalMessage: String?
    var modalButtonText: String?
    
    func config(title: String, message: String, buttonText: String) {
        modalTitle = title
        modalMessage = message
        modalButtonText = buttonText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let modalTitle = self.modalTitle, let modalMessage = self.modalMessage, let modalButtonText = self.modalButtonText else {return}
        titleLbl.text = modalTitle
        messageLbl.text = modalMessage
        button.setTitle(modalButtonText, for: .normal)
    }
    
    @IBAction func btnWasPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
}
