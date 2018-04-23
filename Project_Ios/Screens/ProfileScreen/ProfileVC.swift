//
//  ProfileVC.swift
//  Project_Ios
//
//  Created by iosdev on 13.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
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
    
    func onLogoutSuccess()
    
}

class ProfileVC: UIViewController, ProfileViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: Outlets
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var recycleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRankLabel: UILabel!
    @IBOutlet weak var contactUserButton: UIButton!
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

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ProfilePresenter(view: self)
       
        userItemCollectionView.delegate = self
        userItemCollectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.loadUserInfo()
        presenter?.loadMyItems()
    }

    @IBAction func logOutBtnWasPressed(_ sender: Any) {
        
        let alertViewController = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.presenter?.logout()
        }
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertViewController.addAction(okAction)
        alertViewController.addAction(cancleAction)
        present(alertViewController, animated: true)
    }
    
    
    func onLogoutSuccess() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let authVC = storyBoard.instantiateViewController(withIdentifier: AppStoryBoard.authVC.identifier)
        appDelegate.window?.rootViewController = authVC
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func onLoadDataError(error: AppError) {
        //show the error
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppTableCell.profileCell.identifier, for: indexPath) as? ProfileCell else {
            return UICollectionViewCell()
        }
        
        let myItem = myItems[indexPath.row]
        
        cell.config(item: myItem)
        return cell
        
    }
    
    
}
