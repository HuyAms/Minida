//
//  CategoryVC.swift
//  Project_Ios
//
//  Created by iosdev on 20.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var freeCategoryView: UIView!
    @IBOutlet weak var clothesView: UIView!
    @IBOutlet weak var homewareView: UIView!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var foodView: UIView!
    @IBOutlet weak var vehicleView: UIView!
    @IBOutlet weak var deviceView: UIView!
    @IBOutlet weak var accessoriesView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let freeTapGesture = UITapGestureRecognizer(target: self
            , action: #selector(CategoryVC.freeCategoryWasTapped(_:)))
        freeCategoryView.addGestureRecognizer(freeTapGesture)
        
        let clothesTapGesture = UITapGestureRecognizer(target: self
            , action: #selector(CategoryVC.clothesCategoryWasTapped(_:)))
        clothesView.addGestureRecognizer(clothesTapGesture)
        
        let homewareTapGesture = UITapGestureRecognizer(target: self
            , action: #selector(CategoryVC.homewareCategoryWasTapped(_:)))
        homewareView.addGestureRecognizer(homewareTapGesture)
        
        let otherTapGesture = UITapGestureRecognizer(target: self
            , action: #selector(CategoryVC.otherCategoryWasTapped(_:)))
        otherView.addGestureRecognizer(otherTapGesture)
        
        let foodTapGesture = UITapGestureRecognizer(target: self
            , action: #selector(CategoryVC.foodCategoryWasTapped(_:)))
        foodView.addGestureRecognizer(foodTapGesture)
        
        let vehicleTapGesture = UITapGestureRecognizer(target: self
            , action: #selector(CategoryVC.vehicleCategoryWasTapped(_:)))
        vehicleView.addGestureRecognizer(vehicleTapGesture)
        
        let deviceTapGesture = UITapGestureRecognizer(target: self
            , action: #selector(CategoryVC.deviceCategoryWasTapped(_:)))
        deviceView.addGestureRecognizer(deviceTapGesture)
        
        let accessoriesTapGesture = UITapGestureRecognizer(target: self
            , action: #selector(CategoryVC.accessoriesCategoryWasTapped(_:)))
        accessoriesView.addGestureRecognizer(accessoriesTapGesture)
        
    }
    
    @objc private func freeCategoryWasTapped(_ sender: UITapGestureRecognizer) {
        print(sender)
        print("tapp")
    }
    
    @objc private func clothesCategoryWasTapped(_ sender: UITapGestureRecognizer) {
        print("tapp")
    }
    
    @objc private func homewareCategoryWasTapped(_ sender: UITapGestureRecognizer) {
        print("tapp")
    }
    
    @objc private func otherCategoryWasTapped(_ sender: UITapGestureRecognizer) {
        print("tapp")
    }
    
    @objc private func foodCategoryWasTapped(_ sender: UITapGestureRecognizer) {
        print("tapp")
    }
    
    @objc private func vehicleCategoryWasTapped(_ sender: UITapGestureRecognizer) {
        print("tapp")
    }
    
    @objc private func deviceCategoryWasTapped(_ sender: UITapGestureRecognizer) {
        print("tapp")
    }
    
    @objc private func accessoriesCategoryWasTapped(_ sender: UITapGestureRecognizer) {
        print("tapp")
    }
    
    //MARK: Actions
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
    }
    
}
