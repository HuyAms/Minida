//
//  CategoryVC.swift
//  Project_Ios
//
//  Created by iosdev on 20.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

protocol CategoryDelegate {
    func setCategory(category: Category)
}

class CategoryVC: UIViewController {
    
    var delegate: CategoryDelegate? 
    
    //MARK: Outlets
    @IBOutlet weak var freeCategoryView: UIView!
    @IBOutlet weak var clothesView: UIView!
    @IBOutlet weak var homewareView: UIView!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var vehicleView: UIView!
    @IBOutlet weak var deviceView: UIView!
    @IBOutlet weak var accessoriesView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allTapGesture = UITapGestureRecognizer(target: self
            , action: #selector(CategoryVC.allCategoryWasTapped(_:)))
        allView.addGestureRecognizer(allTapGesture)
        
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
        setCategory(category: .free)
    }
    
    @objc private func clothesCategoryWasTapped(_ sender: UITapGestureRecognizer) {
        setCategory(category: .clothing)
    }
    
    @objc private func homewareCategoryWasTapped(_ sender: UITapGestureRecognizer) {
        setCategory(category: .homewares)
    }
    
    @objc private func otherCategoryWasTapped(_ sender: UITapGestureRecognizer) {
        setCategory(category: .others)
    }
    
    @objc private func allCategoryWasTapped(_ sender: UITapGestureRecognizer) {
        setCategory(category: .all)
    }
    
    @objc private func vehicleCategoryWasTapped(_ sender: UITapGestureRecognizer) {
        setCategory(category: .vehicles)
    }
    
    @objc private func deviceCategoryWasTapped(_ sender: UITapGestureRecognizer) {
        setCategory(category: .devices)
    }
    
    @objc private func accessoriesCategoryWasTapped(_ sender: UITapGestureRecognizer) {
        setCategory(category: .accessories)
    }
    
    func setCategory(category: Category) {
        delegate?.setCategory(category: category)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
