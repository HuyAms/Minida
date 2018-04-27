//
//  NotificationVC.swift
//  Project_Ios
//
//  Created by iosdev on 26.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

protocol NotificationVCProtocol {
    
    func showLoading()
    
    func hideLoading()
    
    func showNotificationList()
    
    func hideNotificationList()
    
    func showNoNotificationLbl(message: String)
    
    func hideNoNotificationLbl()
    
    func onGetNotificationsSuccess(notifications: [Notification])
    
    func onShowError(error: AppError)
    
}

class NotificationVC: UIViewController, NotificationVCProtocol {
 
    var presenter: NotiPresenterProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noNotiLbl: UILabel!
    
    var notifications = [Notification]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(HomeVC.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        refreshControl.backgroundColor = UIColor.appLightColor
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = NotificationPresenter(view: self)
        presenter?.performGetMyNotifications()
        tableView.addSubview(self.refreshControl)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    //MARK: Protocols
    func showLoading() {
        if !refreshControl.isRefreshing {
            showLoadingIndicator()
        }
    }
    
    func hideLoading() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        } else {
            hideLoadingIndicator()
        }
    }
    
    func onGetNotificationsSuccess(notifications: [Notification]) {
        self.notifications = notifications
        tableView.reloadData()
    }
    
    func onShowError(error: AppError) {
        showError(message: error.description)
    }
    
    func showNotificationList() {
        tableView.isHidden = false
    }
    
    func hideNotificationList() {
        tableView.isHidden = true
    }
    
    func showNoNotificationLbl(message: String) {
        noNotiLbl.isHidden = false
        noNotiLbl.text = message
    }
    
    func hideNoNotificationLbl() {
        noNotiLbl.isHidden = true
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.performGetMyNotifications()
    }
    
    //MARK: Actions
    @IBAction func closeBtnWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Helper
    private func goToReceiptScreen(orderId: String) {
        guard let receiptVC = storyboard?.instantiateViewController(withIdentifier: AppStoryBoard.receiptVC.identifier) as? ReceiptVC else {return}
        receiptVC.orderId = orderId
        present(receiptVC, animated: true, completion: nil)
    }
}

extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppTableCell.notificationCell.identifier) as? NotificationCell else {
            return UITableViewCell()
        }
        
        let notificaton =  notifications[indexPath.row]
        
        cell.config(notification: notificaton)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        goToReceiptScreen(orderId: notification.order)
    }

}
