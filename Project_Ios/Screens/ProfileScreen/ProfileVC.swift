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

class ProfileVC: UIViewController, ProfileViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK: Outlets
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var recycleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRankLabel: UILabel!
    @IBOutlet weak var contactUserButton: UIButton!
    @IBOutlet weak var logoutUserButton: UIButton!
    @IBOutlet weak var userItemCollectionView: UICollectionView!
    
    //MARK: Properties
    var presenter: ProfilePresenterProtocol?
    
    var myItems = [Item]()
    
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
        userItemCollectionView.delegate = self
        userItemCollectionView.dataSource = self
        
    }

    func onGetMyItemSuccess(myItems: [Item]) {
        print(myItems)
        let numberOfRecycles = myItems.count
        recycleLabel.text = String(numberOfRecycles)
        self.myItems = myItems
        userItemCollectionView.reloadData()
    }
    
    func setRank(rank: Rank) {
        userRankLabel.text = rank.description
    }
    
    func onGetMyItemError(error: AppError) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userItemCell", for: indexPath) as? UserItemCell else {
            return UICollectionViewCell()
        }
        
        let myItem = myItems[indexPath.row]
        
        cell.config(item: myItem)
        return cell

    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("How many items are displayed in table view: ", myItems.count)
//        return myItems.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userItemCell", for: indexPath) as? UserItemCell else {
//            return UITableViewCell()
//        }
//
//        let myItem = myItems[indexPath.row]
//        let itemImage = myItem.imgPath
//        let itemName = myItem.itemName
//
//        cell.config(itemImgPath: itemImage, itemName: itemName)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    
}

