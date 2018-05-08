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
        setupUI()
        if (KeyChainUtil.share.getSeeOnboardingState()) {
            print("Have seen onboarding")
        } else {
            print("Have not seen onboarding")
        }
        
        onboardingOutlet.dataSource = self
        onboardingOutlet.delegate = self
    }
    
    func setupUI() {
        finishIntroBtn.setTitle("Let's Get Started!".localized, for: .normal)
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
                               title: "Welcome to Minida!".localized,
                               description: "Minida is an online marketplace for second-hand items. Sell them to other users or donate to a recycling center near you!".localized,
                               pageIcon: #imageLiteral(resourceName: "first"),
                               color: bgColor,
                               titleColor: fontColor,
                               descriptionColor: fontColor,
                               titleFont: titleFont,
                               descriptionFont: descFont),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onBoarding2"),
                               title: "Acquire Points".localized,
                               description: "All purchases are done with points. Get points by selling and donating items, or buy them with a paycard.".localized,
                               pageIcon: #imageLiteral(resourceName: "first"),
                               color: bgColor,
                               titleColor: fontColor,
                               descriptionColor: fontColor,
                               titleFont: titleFont,
                               descriptionFont: descFont),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onBoarding3"),
                               title: "Enjoy the selection!".localized,
                               description: "The users of Minida offer a wide variety of items and vouchers to choose from!".localized,
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
