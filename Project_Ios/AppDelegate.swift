//
//  AppDelegate.swift
//  Project_Ios
//
//  Created by Dat Truong on 04/04/2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return _locationManager
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
       // setAppRootController()
        
        checkLocationAuthorizationStatus()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        return true
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

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        KeyChainUtil.share.setMyLat(lat: location.coordinate.latitude)
        KeyChainUtil.share.setMyLng(lng: location.coordinate.longitude)
        KeyChainUtil.share.setMyLocationState()
        manager.stopUpdatingLocation()
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
}

