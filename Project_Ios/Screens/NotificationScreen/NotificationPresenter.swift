//
//  NotificationPresenter.swift
//  Project_Ios
//
//  Created by Huy Trinh on 26.4.2018.
//  Copyright © 2018 Huy Trinh. All rights reserved.
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
        notificationService.getMyNotifications(token: token) { [weak self]response in
            self?.view?.hideLoading()
            switch response {
            case .success(let notifications):
                if notifications.count > 0 {
                     self?.view?.hideNoNotificationLbl()
                     self?.view?.showNotificationList()
                } else {
                     self?.view?.hideNotificationList()
                     self?.view?.showNoNotificationLbl()
                }
                self?.view?.onGetNotificationsSuccess(notifications: notifications)
            case .error(let error):
                self?.view?.onShowError(error: error)
            }
        }
    }
}
