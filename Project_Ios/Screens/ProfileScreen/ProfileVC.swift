//
//  ProfileVC.swift
//  Project_Ios
//
//  Created by iosdev on 13.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

enum ProfileItemLoadState {
    case myAvailableItems
    case soldItems
    case boughtItems
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
    
    func hideCollectionView()
    
    func showCollectionView()
    
    func hideNoItemLabel()
    
    func showNoItemLabel(message: String)
    
}

class ProfileVC: UIViewController, ProfileViewProtocol {
    //MARK: Outlets
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var recycleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRankLabel: UILabel!
    @IBOutlet weak var contactUserButton: UIButton!
    @IBOutlet weak var userItemCollectionView: UICollectionView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var noItemLbl: UILabel!
    @IBOutlet weak var boughtItemBtn: UIButton!
    @IBOutlet weak var soldItemBtn: UIButton!
    @IBOutlet weak var allMyItemBtn: UIButton!
    var profileItemLoadState: ProfileItemLoadState = .myAvailableItems
    
    //MARK: Properties
    var presenter: ProfilePresenterProtocol?
    fileprivate let itemsPerRow: CGFloat = 3
    
    var myItems = [Item]()
    var orderDetails = [OrderDetail]()
    
    func onLoadDataSuccess(userData: User) {
        userNameLabel.text = userData.username
        
        if let point = userData.point {
            pointLabel.text = String(point)
        }
        
        if let avatarIcon = userData.avatarPath {
            avatarImage.load(imgUrl: avatarIcon)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ProfilePresenter(view: self)
        userItemCollectionView.delegate = self
        userItemCollectionView.dataSource = self
        
        setActiveTab(profileItemLoadState: profileItemLoadState)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.loadUserInfo()
        presenter?.loadMyItems()
        
        switch profileItemLoadState {
        case .myAvailableItems:
            presenter?.loadMyItems()
        case .soldItems:
            presenter?.performLoadSold()
        case .boughtItems:
            presenter?.performLoadBought()
        }
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
        profileItemLoadState = .myAvailableItems
        presenter?.loadMyItems()
        setActiveTab(profileItemLoadState: profileItemLoadState)
    }
    
    @IBAction func soldBtnWasPressed(_ sender: UIButton) {
        profileItemLoadState = .soldItems
        presenter?.performLoadSold()
        setActiveTab(profileItemLoadState: profileItemLoadState)
    }
    
    @IBAction func boughtBtnWasPressed(_ sender: UIButton) {
        profileItemLoadState = .boughtItems
        presenter?.performLoadBought()
        setActiveTab(profileItemLoadState: profileItemLoadState)
    }
    
    @IBAction func editProfileButtonWasPressed(_ sender: Any) {
        guard let editProfileVC = storyboard?.instantiateViewController(withIdentifier: AppStoryBoard.editProfileVC.identifier) as? EditProfileVC else {return}
        present(editProfileVC, animated: true, completion: nil)
    }
    
    //MARK: Helper
    func setActiveTab(profileItemLoadState: ProfileItemLoadState) {
        allMyItemBtn.backgroundColor = UIColor.appLightColor
        soldItemBtn.backgroundColor = UIColor.appLightColor
        boughtItemBtn.backgroundColor = UIColor.appLightColor
    
        switch profileItemLoadState {
        case .myAvailableItems:
            allMyItemBtn.backgroundColor = UIColor.appDarkColor
        case .soldItems:
            soldItemBtn.backgroundColor = UIColor.appDarkColor
        case .boughtItems:
            boughtItemBtn.backgroundColor = UIColor.appDarkColor
        }
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
        self.orderDetails = orderDetails
        var soldItems = [Item]()
        orderDetails.forEach { (orderDetail) in
            soldItems.append(orderDetail.item)
        }
        myItems = soldItems
        userItemCollectionView.reloadData()
    }
    
    func onGetBoughtItemsSuccess(orderDetails: [OrderDetail]) {
        print(orderDetails)
        self.orderDetails = orderDetails
        var boughtItems = [Item]()
        orderDetails.forEach { (orderDetail) in
            boughtItems.append(orderDetail.item)
        }
        myItems = boughtItems
        userItemCollectionView.reloadData()
    }
    
    func hideCollectionView() {
        userItemCollectionView.isHidden = true
    }
    
    func showCollectionView() {
        userItemCollectionView.isHidden = false
    }
    
    func hideNoItemLabel() {
        noItemLbl.isHidden = true
    }
    
    func showNoItemLabel(message: String) {
        noItemLbl.isHidden = false
        noItemLbl.text = message
    }
    
    private func goToReceiptScreen(orderDetail: OrderDetail) {
         let order = Order(_id: orderDetail._id, item: orderDetail.item._id, seller: orderDetail.seller._id, buyer: orderDetail.buyer._id, time: orderDetail.time)
        guard let receiptVC = storyboard?.instantiateViewController(withIdentifier: AppStoryBoard.receiptVC.identifier) as? ReceiptVC else {return}
        receiptVC.order = order
        present(receiptVC, animated: true, completion: nil)
    }
}

extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size.width / CGFloat(itemsPerRow) - CGFloat(itemsPerRow - 1)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch profileItemLoadState {
        case .soldItems:
            let orderDetail = orderDetails[indexPath.row]
            goToReceiptScreen(orderDetail: orderDetail)
        case .boughtItems:
            let orderDetail = orderDetails[indexPath.row]
            goToReceiptScreen(orderDetail: orderDetail)
        default:
            return
        }
    }
}
