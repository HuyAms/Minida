//
//  VoucherVC.swift
//  Project_Ios
//
//  Created by Dat Truong on 22/04/2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

protocol VoucherVCProtocol: class {
    func showLoading()
    
    func hideLoading()
    
    func onLoadVoucherSuccess(vouchers: [Voucher])
    
    func onLoadVoucherError(error: AppError)
}

class VoucherVC: UIViewController, VoucherVCProtocol {
    
    var presenter: VoucherPresenterProtocol?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(HomeVC.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        refreshControl.backgroundColor = UIColor.appLightColor
        
        return refreshControl
    }()

    @IBOutlet weak var tableView: UITableView!
    var vouchers = [Voucher]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = VoucherPresenter(view: self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.loadVouchers()
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
    
    func onLoadVoucherSuccess(vouchers: [Voucher]) {
        self.vouchers = vouchers
        tableView.reloadData()
    }
    
    func onLoadVoucherError(error: AppError) {
        showError(message: error.description)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.loadVouchers()
    }
    

}

extension VoucherVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vouchers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppTableCell.voucherCell.identifier) as?
            VoucherCell else {
                return UITableViewCell()
        }
        let voucher = vouchers[indexPath.row]
        cell.config(voucher: voucher)
        return cell
    }
}
