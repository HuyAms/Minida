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
    
    @IBOutlet weak var itemImgView: UIImageView!
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
        itemImgView.load(imgUrl: item.imgPath)
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
        //sellerBadgeLbl.text = ""
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
        
    }
}
