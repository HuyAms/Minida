//
//  MainVC.swift
//  Project_Ios
//
//  Created by iosadmin on 15.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit
import SideMenu

class MainVC: UIViewController {
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var menuContainer: UIView!
    fileprivate var selectedIndex = 0
    var viewControllers = [UIViewController]()
   
    
    lazy fileprivate var menuAnimator : MenuTransitionAnimator! = MenuTransitionAnimator(mode: .presentation, shouldPassEventsOutsideMenu: false) { [unowned self] in
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewControllers()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (.some("presentMenu"), let menu as MenuVC):
            menu.selectedItem = selectedIndex
            menu.delegate = self
            menu.transitioningDelegate = self
            menu.modalPresentationStyle = .custom
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension MainVC: MenuVCDelegate {
    func menu(_ menu: MenuVC, didSelectItemAt index: Int) {
        selectedIndex = index
        
        viewControllers.forEach { (vc) in
            remove(asChildViewController: vc)
        }
        
        add(asChildViewController: viewControllers[index])
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func menuDidCancel(_ menu: MenuVC) {
         dismiss(animated: true, completion: nil)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    private func setUpViewControllers() {
        
        //menuContainer.layer.frame = CGRect(x: 30, y: 30, width: 20, height: 20)
        //let b = menuContainer.bounds
        //menuContainer.bounds = CGRect(x: b.origin.x - 40, y: b.origin.y - 40, width: b.size.width - 20, height: b.size.height - 20)

        
        guard let homeVC = storyboard?.instantiateViewController(withIdentifier: AppStoryBoard.homeVC.identifier) else {return}
        guard let mapVC = storyboard?.instantiateViewController(withIdentifier: AppStoryBoard.mapVC.identifier) else {return}
        guard let profileVC = storyboard?.instantiateViewController(withIdentifier: AppStoryBoard.profileVC.identifier) else {return}
        
        viewControllers.append(homeVC)
        viewControllers.append(mapVC)
        viewControllers.append(profileVC)
        
        //Initial controller
        add(asChildViewController: homeVC)
    }
}

extension MainVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting _: UIViewController,
                             source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return menuAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuTransitionAnimator(mode: .dismissal)
    }
}
