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
        let bgOne = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        let bgTwo = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        let bgThree = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        
        let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 18)!
        let descFont = UIFont(name: "HelveticaNeue", size: 14)!
        
        return [
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "icon"),
                               title: "title",
                               description: "description",
                               pageIcon: #imageLiteral(resourceName: "first"),
                               color: bgOne,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descFont),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "icon"),
                               title: "title",
                               description: "description",
                               pageIcon: #imageLiteral(resourceName: "first"),
                               color: bgTwo,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descFont),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "icon"),
                               title: "title",
                               description: "description",
                               pageIcon: #imageLiteral(resourceName: "first"),
                               color: bgThree,
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
