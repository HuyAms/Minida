//
//  SuccessModalVC.swift
//  Project_Ios
//
//  Created by iosdev on 23.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

enum AlertType {
    case success
    case error
}

class AlertModalVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var modalBackGround: UIView!
    @IBOutlet weak var alertIcon: UIImageView!
    
    var modalTitle: String?
    var modalMessage: String?
    var modalButtonText: String?
    var modalAlertType:AlertType?
    var completion: (()->Void)?
    
    func config(title: String, message: String, buttonText: String, alertType: AlertType, completion: (()->Void)? = nil) {
        modalTitle = title
        modalMessage = message
        modalButtonText = buttonText
        modalAlertType = alertType
        self.completion = completion
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let modalTitle = self.modalTitle, let modalMessage = self.modalMessage, let modalButtonText = self.modalButtonText else {return}
        titleLbl.text = modalTitle
        messageLbl.text = modalMessage
        button.setTitle(modalButtonText, for: .normal)
        
        if let alertType = self.modalAlertType {
            switch alertType {
            case .error:
                alertIcon.image = UIImage.getErrorIcon()
                modalBackGround.backgroundColor = UIColor.errorColor
            case .success:
                alertIcon.image = UIImage.getSuccessIcon()
                modalBackGround.backgroundColor = UIColor.appDefaultColor
            }
        }
    }
    
    @IBAction func btnWasPressed(_ sender: Any) {
        dismiss(animated: false, completion: completion)
    }
    
}
