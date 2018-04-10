//
//  UIViewControllerExt.swift
//  Project_Ios
//
//  Created by Dat Truong on 04/04/2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

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
    
}

