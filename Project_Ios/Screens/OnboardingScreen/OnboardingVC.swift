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
        let bgColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let fontColor = #colorLiteral(red: 0.3098687066, green: 0.2559407552, blue: 0.5042588976, alpha: 1)
        //let bgTwo = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        
        let titleFont = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 30)!
        let descFont = UIFont(name: "AppleSDGothicNeo-Light", size: 20)!
        
        return [
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onBoarding1"),
                               title: "Sell and Donate...",
                               description: "..your items that you do not use anymore.",
                               pageIcon: #imageLiteral(resourceName: "first"),
                               color: bgColor,
                               titleColor: fontColor,
                               descriptionColor: fontColor,
                               titleFont: titleFont,
                               descriptionFont: descFont),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onBoarding2"),
                               title: "Receive Points...",
                               description: "...for donating and selling items.",
                               pageIcon: #imageLiteral(resourceName: "first"),
                               color: bgColor,
                               titleColor: fontColor,
                               descriptionColor: fontColor,
                               titleFont: titleFont,
                               descriptionFont: descFont),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onBoarding3"),
                               title: "Enjoy the selection!",
                               description: "Our users are selling a wide variety of items that might be the treasure you are trying to find.",
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
