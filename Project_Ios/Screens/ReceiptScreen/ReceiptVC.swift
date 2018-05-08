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
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var sellerLbl: UILabel!
    @IBOutlet weak var badgeLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contactBtn: UIButton!
    
    var presenter: ReceiptPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter = ReceiptPresenter(view: self)
   
        if let orderId = self.orderId {
        presenter?.performGetOrder(orderId: orderId)
        }
    }
    
    func onGetOrderSuccess(order: OrderDetail) {
        itemImageView.load(imgUrl: order.item.imgPath)
        itemNameLbl.text = order.item.itemName
        itemPriceLbl.text = String(order.item.price)
        sellerBadgeLbl.text = Badge(badge: order.seller.badge).description
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
    
    func setupUI() {
        titleLbl.text = "Receipt".localized
        priceLbl.text = "Price:".localized
        nameLbl.text = "Name:".localized
        badgeLbl.text = "Badge:".localized
        sellerLbl.text = "Seller:".localized
        timeLbl.text = "Time:".localized
        contactBtn.setTitle("Contact".localized, for: .normal)
    }
    
    func makePhoneCall() {
        guard let phoneNumber = self.phoneNumber else {return}
        guard let phone = URL(string: "tel://0" + String(phoneNumber)) else {return}
        UIApplication.shared.open(phone, options: [:], completionHandler: nil)
    }
    
    //MARK: Actions
    @IBAction func closeBtnWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func contactBtnWasPressed(_ sender: UIButton) {
        
        let alertViewController = UIAlertController(title: "Contact".localized, message: "How do you want to contact?".localized, preferredStyle: .actionSheet)
        let emailAction = UIAlertAction(title: "Email".localized, style: .default) { [weak self](action) in
            self?.openEmail()
        }
        let callAction = UIAlertAction(title: "Phone Number".localized, style: .default) { [weak self](action) in
            self?.makePhoneCall()
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        
        alertViewController.addAction(callAction)
        alertViewController.addAction(emailAction)
        alertViewController.addAction(cancelAction)
        
        present(alertViewController, animated: true)
    }
}
