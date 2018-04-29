//
//  UIViewControllerExt.swift
//  Project_Ios
//
//  Created by Dat Truong on 04/04/2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit
import SVProgressHUD
import Kingfisher

extension UIViewController {
    func presentWithTransition(_ viewControllerToPresent: UIViewController,
                               animated: Bool,
                               completion:(() -> Void)? = nil ) {
        let transition = CATransition()
        transition.duration = 0.1
        self.view.window?.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: animated, completion: completion)
    }
    
    func dismissWithTransition(animated: Bool, completion: (() -> Void)? = nil){
        let transition = CATransition()
        transition.duration = 0.1
        self.view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: animated, completion: completion)
    }
    
    func showLoadingIndicator() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setBackgroundColor(.clear)
        SVProgressHUD.setRingThickness(CGFloat(4))
        SVProgressHUD.setForegroundColor(UIColor.appDarkColor)
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.show()
    }
    
    func hideLoadingIndicator() {
        if UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        SVProgressHUD.dismiss()
    }
    
    func showError(title: String = "Oops!", message: String, closeBtnText: String = "OK") {
        let alertModal = AlertModalVC()
        alertModal.config(title: title, message: message, buttonText: closeBtnText, alertType: .error)
        alertModal.modalPresentationStyle = .custom
        present(alertModal, animated: false, completion: nil)
    }
    
    func showSuccess(title: String = "Great!", message: String, closeBtnText: String = "OK", completion: (()->Void)? = nil) {
        let alertModal = AlertModalVC()
        alertModal.config(title: title, message: message, buttonText: closeBtnText, alertType: .success, completion: completion)
        alertModal.modalPresentationStyle = .custom
        present(alertModal, animated: false, completion: nil)
    }
    
    
}

extension UIImageView {
    func load(imgUrl: String) {
        if !imgUrl.isEmpty {
            let url = URL(string: imgUrl)
            self.kf.setImage(with: url)
        }
    }
}


extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [self.center.x, self.center.x+10, self.center.x-10, self.center.x+10, self.center.x-5, self.center.x+5, self.center.x-5, self.center.x ]
        animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        animation.duration = 0.4
        self.layer.add(animation, forKey: nil)
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}



