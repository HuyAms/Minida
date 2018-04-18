//
//  UIViewControllerExt.swift
//  Project_Ios
//
//  Created by Dat Truong on 04/04/2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit
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
        
    }
    
    func hideLoadingIndicator() {
        
    }
}

extension UIImage {
    static func getTouchIdImage() -> UIImage {
        return UIImage(named: "Touch-icon-lg")!
    }
    
    static func getFaceIdImage() -> UIImage {
        return UIImage(named: "FaceIcon")!
    }
}

extension UIImageView { 
    func loadImage(imgPath: String) {
        let url = URL(string: imgPath)
        self.kf.setImage(with: url)
    }
}

