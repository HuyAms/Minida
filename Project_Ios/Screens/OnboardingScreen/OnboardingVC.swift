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
        let bgColor = #colorLiteral(red: 0.1935226917, green: 0.1895914376, blue: 0.3238024116, alpha: 1)
        //let bgTwo = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        
        let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 30)!
        let descFont = UIFont(name: "HelveticaNeue", size: 20)!
        
        return [
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onBoarding1"),
                               title: "title",
                               description: "description",
                               pageIcon: #imageLiteral(resourceName: "first"),
                               color: bgColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descFont),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onBoarding2"),
                               title: "title",
                               description: "description",
                               pageIcon: #imageLiteral(resourceName: "first"),
                               color: bgColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descFont),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onBoarding3"),
                               title: "title",
                               description: "description",
                               pageIcon: #imageLiteral(resourceName: "first"),
                               color: bgColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
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
    
    func onboardingConfigurationItem(_: OnboardingContentViewItem, index _: Int) {
        
    }
}
