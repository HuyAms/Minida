//
//  TabBarController.swift
//  Project_Ios
//
//  Created by iosdev on 2.5.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    private var currentTabIndex = 0
    private let nc = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        nc.addObserver(self, selector: #selector(onPostSucess), name: NSNotification.Name("postSuccess"), object: nil)
    }
    
    @objc func onPostSucess(notification: NSNotification) {
        self.selectedIndex = 0
        currentTabIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedIndex = currentTabIndex
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex != 2 {
            currentTabIndex = tabBarIndex
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let _ = viewController as? PostVC {
            let postVC = storyboard?.instantiateViewController(withIdentifier: AppStoryBoard.postVC.identifier) as! PostVC
            present(postVC, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }

}
