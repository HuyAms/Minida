//
//  ReceiptVC.swift
//  Project_Ios
//
//  Created by iosdev on 24.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

protocol ReceiptVCProtocol: class {
    
    func onGetOrderSuccess(order: OrderDetail)
    
    func onShowError(error: AppError)

    func showLoading()
    
    func hideLoading()
}

class ReceiptVC: UIViewController, ReceiptVCProtocol {
 
    var orderId: String?
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
   
        if let orderId = self.orderId {
            presenter?.performGetOrder(orderId: orderId)
        }
    }
    
    func onGetOrderSuccess(order: OrderDetail) {
        itemImageView.load(imgUrl: order.item.imgPath)
        itemNameLbl.text = order.item.itemName
        itemPriceLbl.text = String(order.item.price)
        
        sellerNameLbl.text = order.seller.username
        self.email = order.seller.email
        self.phoneNumber = order.seller.phoneNumber
        
        let time = AppUtil.shared.formantTimeStamp(isoDate: order.time)
        receiptTimeLbl.text = time
    }
    
    func onShowError(error: AppError) {
        showError(message: error.description)
    }
    
    func showLoading() {
        showLoadingIndicator()
    }
    
    func hideLoading() {
        hideLoadingIndicator()
    }
    
    //Helper
    func openEmail() {
        guard let email = self.email else {return}
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    func makePhoneCall() {
        guard let phoneNumber = self.phoneNumber else {return}
        guard let phone = URL(string: "tel://" + String(phoneNumber)) else {return}
        UIApplication.shared.open(phone, options: [:], completionHandler: nil)
    }
    
    //MARK: Actions
    @IBAction func closeBtnWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func contactBtnWasPressed(_ sender: UIButton) {
        
        let alertViewController = UIAlertController(title: "Contact", message: "How do you want to contact?", preferredStyle: .actionSheet)
        let emailAction = UIAlertAction(title: "Email", style: .default) { [weak self](action) in
            self?.openEmail()
        }
        let callAction = UIAlertAction(title: "Phone Number", style: .default) { [weak self](action) in
            self?.makePhoneCall()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertViewController.addAction(callAction)
        alertViewController.addAction(emailAction)
        alertViewController.addAction(cancelAction)
        
        present(alertViewController, animated: true)
    }
}
