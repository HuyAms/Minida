//
//  OnboardingVC.swift
//  Project_Ios
//
//  Created by iosdev on 12.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var onboardingOutlet: OnboardingOB!
    @IBOutlet weak var finishIntroBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (KeyChainUtil.share.getSeeOnboardingState()) {
            print("Have seen onboarding")
        } else {
            print("Have not seen onboarding")
        }
        
        onboardingOutlet.dataSource = self
        onboardingOutlet.delegate = self
    }
    
    // MARK: Actions
    @IBAction func finishIntroBtnWasPressed(_ sender: Any) {
        KeyChainUtil.share.setSeeOnboardingState()
    }
    
}


extension OnboardingVC: PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    // MARK: Onboarding DataSource functions
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let bgColor = UIColor(red: 235.0 / 255.0, green: 234.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
        let fontColor = UIColor(red: 70.0 / 255.0, green: 65.0 / 255.0, blue: 125.0 / 255.0, alpha: 1.0) 
        
        let titleFont = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 30)!
        let descFont = UIFont(name: "AppleSDGothicNeo-Light", size: 20)!
        
        return [
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onBoarding1"),
                               title: "Welcome to Minida!",
                               description: "Minida is an online marketplace for your unused items. Sell them to other users or donate to a recycling center near you!",
                               pageIcon: #imageLiteral(resourceName: "first"),
                               color: bgColor,
                               titleColor: fontColor,
                               descriptionColor: fontColor,
                               titleFont: titleFont,
                               descriptionFont: descFont),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onBoarding2"),
                               title: "Acquire Points",
                               description: "All purchases are done with points. Get points by selling and donating items or just use a paycard!",
                               pageIcon: #imageLiteral(resourceName: "first"),
                               color: bgColor,
                               titleColor: fontColor,
                               descriptionColor: fontColor,
                               titleFont: titleFont,
                               descriptionFont: descFont),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onBoarding3"),
                               title: "Enjoy the selection!",
                               description: "Minida offers you a wide variety of items and vouchers  to choose from!",
                               pageIcon: #imageLiteral(resourceName: "first"),
                               color: bgColor,
                               titleColor: fontColor,
                               descriptionColor: fontColor,
                               titleFont: titleFont,
                               descriptionFont: descFont),
            ][index]
    }
    
    // MARK: Onboarding Delegate functions
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 2 {
            finishIntroBtn.isHidden = false
            
            UIView.animate(withDuration: 0.6, animations: {
                self.finishIntroBtn.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: { _ in
             UIView.animate(withDuration: 0.6) {
                self.finishIntroBtn.transform = CGAffineTransform.identity
            }})
        }
        
        
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index != 2 && finishIntroBtn.isHidden == false {
            finishIntroBtn.isHidden = true
        }
    }
    
    func onboardingConfigurationItem(item: OnboardingContentViewItem, index _: Int) {
        
    }
}
