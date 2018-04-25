//
//  ProfileVC.swift
//  Project_Ios
//
//  Created by iosdev on 13.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

enum ProfileItemLoadState {
    case onSale
    case sold
    case bought
}

protocol ProfileViewProtocol: class {
    
    func onLoadDataSuccess(userData: User)
    
    func onLoadDataError(error: AppError)
    
    func showLoading()
    
    func hideLoading()
    
    func onGetMyItemSuccess(myItems: [Item])
    
    func onGetMyItemError(error: AppError)
    
    func onGetSoldItemsSuccess(orderDetails: [OrderDetail])
    
    func onGetBoughtItemsSuccess(orderDetails: [OrderDetail])
    
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
    var profileItemLoadState: ProfileItemLoadState = .onSale
    
    //MARK: Properties
    var presenter: ProfilePresenterProtocol?
    
    var myItems = [Item]()
    
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
        
//        switch profileItemLoadState {
//        case .onSale:
//            presenter?.loadMyItems()
//        case .sold:
//            presenter?.performLoadSold()
//        case .bought:
//            presenter?.performLoadBought()
//        default:
//            presenter?.loadMyItems()
//        }
    }

    //MARK: Actions
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
    
    @IBAction func myItemsBtnWasPressed(_ sender: UIButton) {
        print("my item was pressed")
        profileItemLoadState = .onSale
        presenter?.loadMyItems()
    }
    
    @IBAction func soldBtnWasPressed(_ sender: UIButton) {
        print("my soldBtnWasPressed was pressed")

        profileItemLoadState = .sold
        presenter?.performLoadSold()

    }
    
    @IBAction func boughtBtnWasPressed(_ sender: UIButton) {
        print("my boughtBtnWasPressed was pressed")

        profileItemLoadState = .bought
        presenter?.performLoadBought()

    }
    
    //MARK: Protocols
    func onLogoutSuccess() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let authVC = storyBoard.instantiateViewController(withIdentifier: AppStoryBoard.authVC.identifier)
        appDelegate.window?.rootViewController = authVC
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func onLoadDataError(error: AppError) {
        showError(message: error.description)
    }
    
    func showLoading() {
        showLoadingIndicator()
    }
    
    func hideLoading() {
        hideLoadingIndicator()
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
        showError(message: error.description)
    }
    
    func onGetSoldItemsSuccess(orderDetails: [OrderDetail]) {
        print(orderDetails)

        var soldItems = [Item]()
        orderDetails.forEach { (orderDetail) in
            soldItems.append(orderDetail.item)
        }
        myItems = soldItems
        userItemCollectionView.reloadData()
    }
    
    func onGetBoughtItemsSuccess(orderDetails: [OrderDetail]) {
        print(orderDetails)

        var boughtItems = [Item]()
        orderDetails.forEach { (orderDetail) in
            boughtItems.append(orderDetail.item)
        }
        myItems = boughtItems
        userItemCollectionView.reloadData()
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
