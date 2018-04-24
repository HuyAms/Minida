//
//  ReceiptVC.swift
//  Project_Ios
//
//  Created by iosdev on 24.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

protocol ReceiptVCProtocol: class {
    
    func onFetchItemSuccess(item: ItemHome)
    
    func onFetchSellerSuccess(seller: User)
    
    func onShowError(error: AppError)

    func showLoading()
    
    func hideLoading()
}

class ReceiptVC: UIViewController, ReceiptVCProtocol {
    
    var order: Order?
    var email: String?
    var phoneNumber: Int?
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemPriceLbl: UILabel!
    @IBOutlet weak var sellerNameLbl: UILabel!
    @IBOutlet weak var sellerBadgeLbl: UILabel!
    @IBOutlet weak var receiptTimeLbl: UILabel!
    
    var presenter: ReceiptPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ReceiptPresenter(view: self)
        
        if let order = self.order {
            let sellerId = order.seller
            let itemId = order.item
            
            presenter?.performGetItem(itemId: itemId)
            presenter?.performGetSeller(userId: sellerId)
            
            let time = AppUtil.shared.formantTimeStamp(isoDate: order.time)
            receiptTimeLbl.text = time
        }
    }
    
    func onShowError(error: AppError) {
        showError(message: error.description)
    }
    
    func onFetchItemSuccess(item: ItemHome) {
        itemImageView.load(imgUrl: item.imgPath)
        itemNameLbl.text = item.itemName
        
        let price = item.price
        switch price {
        case 0:
            itemPriceLbl.text = "FREE"
        case 1:
            itemPriceLbl.text = "\(String(item.price)) point"
        default:
            itemPriceLbl.text = "\(String(item.price)) points"
        }
    }
    
    func onFetchSellerSuccess(seller: User) {
        sellerNameLbl.text = seller.username
        email = seller.email
        phoneNumber = seller.phoneNumber
    }
    
    func showLoading() {
        showLoadingIndicator()
    }
    
    func hideLoading() {
        hideLoadingIndicator()
    }
    
    
    //MARK: Actions
    @IBAction func closeBtnWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func contactBtnWasPressed(_ sender: UIButton) {
        
        let alertViewController = UIAlertController(title: "Contact", message: "How do you want to contact?", preferredStyle: .actionSheet)
        let emailAction = UIAlertAction(title: "Email", style: .default) { (action) in
            guard let email = self.email else {return}
            if let url = URL(string: "mailto:\(email)") {
                UIApplication.shared.open(url)
            }
        }
        let callAction = UIAlertAction(title: "Phone Number", style: .default) { (action) in
            guard let phoneNumber = self.phoneNumber else {return}
            guard let phone = URL(string: "tel://" + String(phoneNumber)) else {return}
            UIApplication.shared.open(phone, options: [:], completionHandler: nil)
            print("phone number chosen")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertViewController.addAction(callAction)
        alertViewController.addAction(emailAction)
        alertViewController.addAction(cancelAction)
        present(alertViewController, animated: true)
    }
}
