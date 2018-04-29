//
//  PostPresenter.swift
//  Project_Ios
//
//  Created by iosdev on 29.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

protocol PostPresenterProtocol {
    
    func performUploadItem(itemName: String, itemDescription: String, itemPrice:String, itemCategory: String, itemPictureUrl: String)
    
    func upLoadPicture(imgData: Data?)
    
    func validateData(itemName: String, itemDescription: String, itemPrice: String, itemCategory: String)
}

class PostPresenter: PostPresenterProtocol {
    
    func validateData(itemName: String, itemDescription: String, itemPrice: String, itemCategory: String) {
        
        if itemName.isEmpty || itemDescription.isEmpty || itemPrice.isEmpty || itemCategory.isEmpty {
            view?.onShowError(error: .emptyField)
            return
        }
        
        guard let _ = Int(itemPrice) else {
            view?.onShowError(error: .invalidPrice)
            return
        }
        
        view?.onValidateDataSuccess()
        
    }
    
    fileprivate weak var view:  PostVCProtocol?
    let itemService: ItemServiceProtocol = ItemService()
    let uploadImgService: UpLoadImgServiceProtocol = UploadImgService()
    
    init(view: PostVCProtocol) {
        self.view = view
    }
    
    func performUploadItem(itemName: String, itemDescription: String, itemPrice: String, itemCategory: String, itemPictureUrl: String) {
        guard let itemPrice = Int(itemPrice) else {
            view?.onShowError(error: .invalidPrice)
            return
        }
    
        guard let token = KeyChainUtil.share.getToken() else {
            print("Empty token")
            return
        }
        let lat = KeyChainUtil.share.getMyLat()
        let lng = KeyChainUtil.share.getMyLng()
        
        view?.showLoading()
        itemService.postItemForSale(token: token, itemName: itemName, description: itemDescription, price: itemPrice, itemCategory: itemCategory, imgPath: itemPictureUrl, lat: lat, lng: lng) {[weak self] (response) in
            self?.view?.hideLoading()
            switch response {
            case .success(_):
                self?.view?.onPostSuccess()
            case .error(let error):
                self?.view?.onShowError(error: error)
            }
        }
    }
    
    
    func upLoadPicture(imgData: Data?) {
        guard let token = KeyChainUtil.share.getToken() else {
            print("Empty token")
            return
        }

        guard let imgData = imgData  else {
            view?.onShowError(error: .emptyImage)
            return
        }

        view?.showLoading()
        uploadImgService.uploadImg(token: token, imgData: imgData) { [weak self](response) in
            self?.view?.hideLoading()
            switch response {
            case .success(let upLoadResponse):
                let imgPath = "\(URLConst.BASE_URL)/photos/\(upLoadResponse.filename)"
                self?.view?.onUploadImageSuccess(imgPath: imgPath)
            case .error(let error):
                self?.view?.onShowError(error: error)
            }
        }
    }
    
    
}
