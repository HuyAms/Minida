//
//  MapPresenter.swift
//  Project_Ios
//
//  Created by Huy Trinh on 11.4.2018.
//  Copyright © 2018 Huy Trinh. All rights reserved.
//

import Foundation

protocol MapPresenterProtocol {
    
    func loadCenterInfo()
    
    func getMyLocation()
    
}

class MapPresenter: MapPresenterProtocol {
    
    weak var view: MapViewProtocol?
    var recycleCenterService: RecycleCenterServiceProtocol = RecycleCenterService()
    
    init(view: MapViewProtocol) {
        self.view = view
    }
    
    func loadCenterInfo() {
        view?.showLoading()
        recycleCenterService.loadReycleCenters{ [weak self] (response) in
            switch response {
            case .success(let centerList):
                self?.view?.onLoadDataSuccess(centerList: centerList)
                self?.view?.hideLoading()
            case .error(let error):
                self?.view?.onLoadDataError(error: error)
                self?.view?.hideLoading()
            }
        }
    }
    
    func getMyLocation() {
        if (KeyChainUtil.share.getMyLocationState()) {
            let myLat = KeyChainUtil.share.getMyLat()
            let myLng = KeyChainUtil.share.getMyLng()
            view?.onGetMyLocationSuccess(lat: myLat, lng: myLng)
        } else {
            view?.onGetMyLocationError()
        }
    }
    
    
}
