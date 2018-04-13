//
//  ProfileVC.swift
//  Project_Ios
//
//  Created by iosdev on 04/04/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import UIKit

protocol ProfileViewProtocol: class {
    
    func onLoadDataSuccess(userData: User)
    
    func onLoadDataError(error: AppError)
    
    func showLoading()
    
    func hideLoading()
    
    func onGetMyItemSuccess(myItems: [Item])
    
    func onGetMyItemError(error: AppError)
    
    func setRank(rank: Rank)
    
}
    

class ProfileVC: UIViewController, ProfileViewProtocol {
    
    //MARK: Outlets
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var recycleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRankLabel: UILabel!
    @IBOutlet weak var contactUserButton: UIButton!
    @IBOutlet weak var logoutUserButton: UIButton!
    
    //MARK: Properties
    var presenter: ProfilePresenterProtocol?
    
    //MARK: Actions
    func onLoadDataSuccess(userData: User) {
       userNameLabel.text = userData.username
        
        if let point = userData.point {
            pointLabel.text = String(point)
        }
        
    }
    
    func onLoadDataError(error: AppError) {
        //show the error
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ProfilePresenter(view: self)
        presenter?.loadUserInfo()
        presenter?.loadMyItems()
    }

    func onGetMyItemSuccess(myItems: [Item]) {
        print(myItems)
        let numberOfRecycles = myItems.count
        recycleLabel.text = String(numberOfRecycles)
    }
    
    func setRank(rank: Rank) {
        userRankLabel.text = rank.description
    }
    
    func onGetMyItemError(error: AppError) {
        
    }


}

