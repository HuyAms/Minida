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

enum ProfileLoadState {
    case myProfile
    case userProfile
}

protocol ProfileViewProtocol: class {
    
    func onLoadDataSuccess(userData: User)
    
    func onLoadDataError(error: AppError)
    
    func showLoading()
    
    func hideLoading()
    
    func onGetMyItemSuccess(items: [Item])
    
    func onGetMyItemError(error: AppError)
    
    func onGetSoldItemsSuccess(orderDetails: [OrderDetail])
    
    func onGetBoughtItemsSuccess(orderDetails: [OrderDetail])
    
    func onLogoutSuccess()
    
    func hideCollectionView()
    
    func showCollectionView()
    
    func hideNoItemLabel()
    
    func showNoItemLabel(message: String)
    
    func setUpLoadMyProfile()
    
    func setUpLoadUserProfile()
}

class ProfileVC: UIViewController, ProfileViewProtocol {
 
    //MARK: Outlets
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var pointNumberLbl: UILabel!
    @IBOutlet weak var recycleNumberLbl: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRankLabel: UILabel!
    @IBOutlet weak var userItemCollectionView: UICollectionView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var noItemLbl: UILabel!
    @IBOutlet weak var boughtItemBtn: UIButton!
    @IBOutlet weak var soldItemBtn: UIButton!
    @IBOutlet weak var onSaleBtn: UIButton!
    @IBOutlet weak var qrCodeView: UIView!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var boardViewBtn: UIButton!
    @IBOutlet weak var pointStack: UIStackView!
    @IBOutlet weak var addPointStack: UIStackView!
    @IBOutlet weak var addPointLbl: UILabel!
    @IBOutlet weak var badgeLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var recyclesLbl: UILabel!
    
    //MARK: Properties
    var presenter: ProfilePresenterProtocol?
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate var myItems = [Item]()
    var profileItemLoadState: ProfileItemLoadState = .myAvailableItems
    var profileLoadState: ProfileLoadState = .myProfile
    var userId: String? = nil
    fileprivate var orderDetails = [OrderDetail]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter = ProfilePresenter(view: self)
        userItemCollectionView.delegate = self
        userItemCollectionView.dataSource = self
        
        setActiveTab(profileItemLoadState: profileItemLoadState)
        
        let avaGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.avatarTapHandler(_:)))
        avatarImage.addGestureRecognizer(avaGesture)
        
        let qrGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.qrTapHandler(_:)))
        qrCodeView.addGestureRecognizer(qrGesture)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch profileLoadState {
        case .myProfile:
            presenter?.loadUserInfo()
            switch profileItemLoadState {
            case .myAvailableItems:
                presenter?.loadMyItems()
            case .soldItems:
                presenter?.performLoadSold()
            case .boughtItems:
                presenter?.performLoadBought()
            }
        case .userProfile:
            if let userId = self.userId {
                presenter?.loadUserInfo(userId: userId)
                presenter?.loadUserItems(userId: userId)
            }
        }
    }
    

    //MARK: Actions
    @IBAction func logOutBtnWasPressed(_ sender: Any) {
        
        let alertViewController = UIAlertController(title: "Log out".localized, message: "Are you sure you want to log out?".localized, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK".localized, style: .default) { (action) in
            self.presenter?.logout()
        }
        let cancleAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alertViewController.addAction(okAction)
        alertViewController.addAction(cancleAction)
        present(alertViewController, animated: true)
    }
    
    @IBAction func paymentBtnWasPressed(_ sender: Any) {
        guard let paymentVC = storyboard?.instantiateViewController(withIdentifier: AppStoryBoard.paymentVC.identifier) as? PaymentVC else {return}
        present(paymentVC, animated: true, completion: nil)
    }
    
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    @IBAction func leaderBoardBtnWasPressed(_ sender: Any) {
        guard let leaderBoardVC = storyboard?.instantiateViewController(withIdentifier: AppStoryBoard.leaderBoardVC.identifier) as? LeaderBoardVC else {return}
        present(leaderBoardVC, animated: true, completion: nil)
    }
    
    //MARK: Helper
    func setActiveTab(profileItemLoadState: ProfileItemLoadState) {
        onSaleBtn.backgroundColor = UIColor.appLightColor
        soldItemBtn.backgroundColor = UIColor.appLightColor
        boughtItemBtn.backgroundColor = UIColor.appLightColor
    
        switch profileItemLoadState {
        case .myAvailableItems:
            onSaleBtn.backgroundColor = UIColor.appDarkColor
        case .soldItems:
            soldItemBtn.backgroundColor = UIColor.appDarkColor
        case .boughtItems:
            boughtItemBtn.backgroundColor = UIColor.appDarkColor
        }
    }
    
    @objc func avatarTapHandler(_ sender: UITapGestureRecognizer) {
        UIView.transition(with: self.qrCodeView, duration: 0.7 , options: .transitionCrossDissolve, animations: {
            self.qrCodeView.isHidden = false
        }, completion: nil)
    }
    
    
    @objc func qrTapHandler(_ sender: UITapGestureRecognizer) {
        UIView.transition(with: self.qrCodeView, duration: 0.7 , options: .transitionCrossDissolve, animations: {
            self.qrCodeView.isHidden = true
        }, completion: nil)
    }
    
    func setUpLoadMyProfile() {
        pointStack.isHidden = false
        onSaleBtn.isHidden = false
        soldItemBtn.isHidden = false
        boughtItemBtn.isHidden = false
        editProfileBtn.isHidden = false
        boardViewBtn.isHidden = false
        logOutBtn.isHidden = false
        closeBtn.isHidden = true
        addPointStack.isHidden = false
    }
    
    func setUpLoadUserProfile() {
        pointStack.isHidden = true
        onSaleBtn.isHidden = true
        soldItemBtn.isHidden = true
        boughtItemBtn.isHidden = true
        editProfileBtn.isHidden = true
        boardViewBtn.isHidden = true
        logOutBtn.isHidden = true
        closeBtn.isHidden = false
        addPointStack.isHidden = true
    }
    
    func setupUI() {
        addPointLbl.text = "Add Point".localized
        badgeLbl.text = "Badge".localized
        pointsLbl.text = "Points".localized
        recyclesLbl.text = "Recycles".localized
        editProfileBtn.setTitle("Edit Profile".localized, for: .normal)
        boardViewBtn.setTitle("Leaderboard".localized, for: .normal)
        onSaleBtn.setTitle("On Sale".localized, for: .normal)
        soldItemBtn.setTitle("Sold".localized, for: .normal)
        boughtItemBtn.setTitle("Bought".localized, for: .normal)
    }
    
    
    //MARK: Protocols
    
    func onLoadDataSuccess(userData: User) {
        userNameLabel.text = userData.username
        
        if let point = userData.point {
            pointNumberLbl.text = String(point)
        }
        
        if let avatarIcon = userData.avatarPath {
            avatarImage.load(imgUrl: avatarIcon)
        }
        
        recycleNumberLbl.text = String(userData.numberOfRecycledItems)
        userRankLabel.text = Badge(badge: userData.badge).description
        badgeImage.image = UIImage.getBadgeIcon(badge: Badge(badge: userData.badge))
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
        showError(message: error.description)
    }
    
    func showLoading() {
        showLoadingIndicator()
    }
    
    func hideLoading() {
        hideLoadingIndicator()
    }
    
    
    func onGetMyItemSuccess(items: [Item]) {
        self.myItems = items
        userItemCollectionView.reloadData()
    }
    
    func onGetMyItemError(error: AppError) {
        showError(message: error.description)
    }
    
    func onGetSoldItemsSuccess(orderDetails: [OrderDetail]) {
        self.orderDetails = orderDetails
        var soldItems = [Item]()
        orderDetails.forEach { (orderDetail) in
            soldItems.append(orderDetail.item)
        }
        myItems = soldItems
        userItemCollectionView.reloadData()
    }
    
    func onGetBoughtItemsSuccess(orderDetails: [OrderDetail]) {
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
        guard let receiptVC = storyboard?.instantiateViewController(withIdentifier: AppStoryBoard.receiptVC.identifier) as? ReceiptVC else {return}
        receiptVC.orderId = orderDetail._id
        present(receiptVC, animated: true, completion: nil)
    }
    
    private func goToItemDetailScreen(itemId: String) {
        guard let itemDetailVC = storyboard?.instantiateViewController(withIdentifier: AppStoryBoard.itemDetailVC.identifier) as? ItemDetailVC else {return}
        itemDetailVC.itemId = itemId
        present(itemDetailVC, animated: true, completion: nil)
    }
}

extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: Collection view functions
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

    // These three set the cell of the view with 3px spacing
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
            goToItemDetailScreen(itemId: myItems[indexPath.row]._id)
            return
        }
    }
}
