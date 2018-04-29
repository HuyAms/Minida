//
//  ItemDetailVC.swift
//  Project_Ios
//
//  Created by Huy Trinh on 29.4.2018.
//  Copyright © 2018 Huy Trinh. All rights reserved.
//

import UIKit

protocol ItemDetailVCProtocol: class {
    
    func showLoading()
    
    func hideLoading()
    
    func onBuyItemSuccess(order: Order)
    
    func onShowError(error: AppError)
    
    func onGetItemSuccess(item: ItemDetail)
}

class ItemDetailVC: UIViewController, ItemDetailVCProtocol{
    //Mark: Outlet
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var numberPointLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var badgeLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var badgeImgView: UIImageView!
    @IBOutlet weak var avatarImgView: UIImageView!
    
    var presenter: ItemDetailPresenterProtocol?
    var itemId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = ItemDetailPresenter(view: self)
        if let itemId = self.itemId {
            presenter?.getItem(itemId: itemId)
        }
    }
    
    
    //MARK: Action
    @IBAction func buyBtnWasPressed(_ sender: Any) {
        let alertViewController = UIAlertController(title: "Buy", message: "Do you want to buy this item?", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            if let itemId = self.itemId {
                self.presenter?.performBuyItem(itemId: itemId)
            }
        }
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertViewController.addAction(okAction)
        alertViewController.addAction(cancleAction)
        self.present(alertViewController, animated: true)
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Helper
    private func goToReceiptScreen(orderId: String) {
        guard let receiptVC = storyboard?.instantiateViewController(withIdentifier: AppStoryBoard.receiptVC.identifier) as? ReceiptVC else {return}
        receiptVC.orderId = orderId
        present(receiptVC, animated: true, completion: nil)
    }
    
    //MARK: Protocol
    func showLoading() {
        showLoadingIndicator()
    }
    
    func hideLoading() {
        hideLoadingIndicator()
    }
    
    func onShowError(error: AppError) {
        showError(message: error.description)
    }
    
    func onGetItemSuccess(item: ItemDetail) {
        itemNameLbl.text = item.itemName
        descriptionLbl.text = item.description
        timeLbl.text = AppUtil.shared.formantTimeStamp(isoDate: item.time)
        badgeLbl.text = item.seller.badge
        usernameLbl.text = item.seller.username
        badgeImgView.image = UIImage.getBadgeIcon(badge: Badge(badge: item.seller.badge))
        
        if let avatarPath = item.seller.avatarPath {
            avatarImgView.load(imgUrl: avatarPath)
        }
        
        let price = item.price
        if price == 0 {
            numberPointLbl.text = "FREE"
        } else if price == 1 {
            numberPointLbl.text = "\(price) point"
        } else {
            numberPointLbl.text = "\(price) points"
        }
    }
    
    func onBuyItemSuccess(order: Order) {
        goToReceiptScreen(orderId: order._id)
    }
}
