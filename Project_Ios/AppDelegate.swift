//
//  AppDelegate.swift
//  Project_Ios
//
//  Created by Dat Truong on 04/04/2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = .lightContent

        setAppRootController()
        setUpStripe()
        
        return true
    }
    
    func setUpStripe() {
        STPPaymentConfiguration.shared().publishableKey = KEY.STRIPE
        
        // Stripe theme configuration
        STPTheme.default().primaryBackgroundColor = UIColor.appPinkWhiteColor
        STPTheme.default().primaryForegroundColor = UIColor.appDefaultColor
        STPTheme.default().secondaryForegroundColor = UIColor.appDefaultColor
        STPTheme.default().secondaryBackgroundColor = UIColor.white
        STPTheme.default().accentColor = UIColor.appDefaultColor
    }
    
    func setAppRootController() {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var rootVC = storyBoard.instantiateViewController(withIdentifier: AppStoryBoard.onBoardingVC.identifier)

        if (KeyChainUtil.share.getLogInState()) {
            rootVC = storyBoard.instantiateViewController(withIdentifier: AppStoryBoard.mainVC.identifier)
        } else {
            if (KeyChainUtil.share.getSeeOnboardingState()) {
                rootVC = storyBoard.instantiateViewController(withIdentifier: AppStoryBoard.authVC.identifier)
            } else {
                rootVC = storyBoard.instantiateViewController(withIdentifier: AppStoryBoard.onBoardingVC.identifier)
            }
        }

        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
}

