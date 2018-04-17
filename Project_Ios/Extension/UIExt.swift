//
//  UIViewControllerExt.swift
//  Project_Ios
//
//  Created by Dat Truong on 04/04/2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit
import SVProgressHUD

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
        SVProgressHUD.show()
    }
    
    func hideLoadingIndicator() {
        SVProgressHUD.dismiss()
    }
}

extension UIImage {
    static func getTouchIdImage() -> UIImage {
        return UIImage(named: "Touch-icon-lg")!
    }
    
    static func getFaceIdImage() -> UIImage {
        return UIImage(named: "FaceIcon")!
    }
    
    static func getMapAnnotationImage() -> UIImage {
        return UIImage(named: "map-location-icon")!
    }
    
    static func getMapBtnImage() -> UIImage {
        return UIImage(named: "Maps-icon")!
    }
}

extension UIView {
    func shake(duration: Double, repeat: Int) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 10, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 10, y: self.center.y)
        self.layer.add(animation, forKey: nil)
    }
}

