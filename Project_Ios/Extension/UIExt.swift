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
        SVProgressHUD.show()
    }
    
    func hideLoadingIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func showError(message: String) {
        present(UIAlertController.init(message: message), animated: true)
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
    
    static func getOthersIconWhite() -> UIImage {
        return UIImage(named: "other-category-icon")!
    }
    
    static func getOthersIconBlack() -> UIImage {
        return UIImage(named: "other-category-black-icon")!
    }
    
    static func getClothingIconWhite() -> UIImage {
        return UIImage(named: "clothes-category-icon")!
    }
    
    static func getClothingIconBlack() -> UIImage {
        return UIImage(named: "clothes-category-black-icon")!
    }
    
    static func getVehiclesIconWhite() -> UIImage {
        return UIImage(named: "vehicles-category-icon")!
    }
    
    static func getVehiclesIconBlack() -> UIImage {
        return UIImage(named: "vehicles-category-black-icon")!
    }
    
    static func getFreeIcon() -> UIImage {
        return UIImage(named: "free-stuff-icon")!
    }

    static func getFoodIconWhite() -> UIImage {
        return UIImage(named: "food-category-icon")!
    }
    
    static func getFoodIconBlack() -> UIImage {
        return UIImage(named: "food-category-icon")!
        //get black food icon
    }
    
    static func getHomewaresIconWhite() -> UIImage {
        return UIImage(named: "homewares-category-icon")!
    }
    
    static func getHomewaresIconBlack() -> UIImage {
        return UIImage(named: "homewares-category-black-icon")!
    }
    
    static func getAccessoriesIconWhite() -> UIImage {
        return UIImage(named: "accessories-category-icon")!
    }
    
    static func getAccessoriesIconBlack() -> UIImage {
        return UIImage(named: "accessories-category-black-icon")!
    }
    
    static func getDevicesIconBlack() -> UIImage {
        return UIImage(named: "device-category-black-icon")!
    }
    
    static func getDevicesIconWhite() -> UIImage {
        return UIImage(named: "device-category-icon")!
    }
}

extension UIImageView {
    
    func load(imgUrl: String) {
        let url = URL(string: imgUrl)
        self.kf.setImage(with: url)
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

extension UIColor {
    static let appDarkColor = UIColor(red: 70.0 / 255.0, green: 65.0 / 255.0, blue: 125.0 / 255.0, alpha: 1.0)         //#46417d
    static let appDefaultColor = UIColor(red: 77.0 / 255.0, green: 71.0 / 255.0, blue: 136.0 / 255.0, alpha: 1.0)         // #4d4788
    static let appLightColor = UIColor(red: 124.0 / 255.0, green: 114.0 / 255.0, blue: 184.0 / 255.0, alpha: 1.0)         // #7c72b8
}

