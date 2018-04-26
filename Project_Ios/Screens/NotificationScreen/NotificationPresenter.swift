//
//  NotificationPresenter.swift
//  Project_Ios
//
//  Created by iosdev on 26.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

protocol NotiPresenterProtocol {
    
    func performGetMyNotifications()
    
}

class NotificationPresenter: NotiPresenterProtocol {
    
    var view: NotificationVCProtocol?
    var notificationService: NotificationServiceProtocol = NotificationService()
    
    init(view: NotificationVCProtocol) {
        self.view = view
    }
    
    func performGetMyNotifications() {
        self.view?.showLoading()
        guard let token = KeyChainUtil.share.getToken() else {return}
        notificationService.getMyNotifications(token: token) { response in
            switch response {
            case .success(let notifications):
                self.view?.hideLoading()
                self.view?.onGetNotificationsSuccess(notifications: notifications)
            case .error(let error):
                self.view?.hideLoading()
                self.view?.onShowError(error: error)
            }
        }
    }
}
