//
//  VoucherVC.swift
//  Project_Ios
//
//  Created by Huy Trinh on 22/04/2018.
//  Copyright © 2018 Huy Trinh. All rights reserved.
//

import UIKit

enum VoucherLoadingState {
    case loadVouchers
    case loadMyVouchers
}

protocol VoucherVCProtocol: class {
    func showLoading()
    
    func hideLoading()
    
    func onLoadVoucherSuccess(vouchers: [Voucher])
    
    func onLoadVoucherError(error: AppError)
    
    func onBuyVoucherSuccess()
    
    func onBuyVoucherError(error: AppError)
    
    func displayNoVoucher()
}

class VoucherVC: UIViewController, VoucherVCProtocol {
   
    var presenter: VoucherPresenterProtocol?
    var voucherLoadingState = VoucherLoadingState.loadVouchers
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(HomeVC.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        refreshControl.backgroundColor = UIColor.appLightColor
        
        return refreshControl
    }()

    @IBOutlet weak var noVoucherLbl: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
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
    
    //MARK: ACTION
    
    @IBAction func segmentDidChange(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            voucherLoadingState = .loadVouchers
            presenter?.loadVouchers()
        case 1:
            voucherLoadingState = .loadMyVouchers
            presenter?.loadMyVouchers()
        default:
            break
        }
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
        tableView.isHidden = false
        noVoucherLbl.isHidden = true
        self.vouchers = vouchers
        tableView.reloadData()
    }
    
    func onLoadVoucherError(error: AppError) {
        showError(message: error.description)
    }
    
    func displayNoVoucher() {
        tableView.isHidden = true
        noVoucherLbl.isHidden = false
    }
    
    func onBuyVoucherSuccess() {
        showSuccess(message: "Buy voucher successfully")
    }
    
    func onBuyVoucherError(error: AppError) {
        showError(message: error.description)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        switch voucherLoadingState {
        case .loadVouchers:
            presenter?.loadVouchers()
        default:
            presenter?.loadMyVouchers()
        }
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
        cell.config(voucher: voucher, voucherLoadingState: voucherLoadingState)
        
        cell.onButtonTapped = { [weak self] () in
            let alertViewController = UIAlertController(title: "Payment", message: "This voucher costs you \(voucher.price) points", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self?.presenter?.buyVouchers(voucherId: voucher._id)
            }
            let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertViewController.addAction(okAction)
            alertViewController.addAction(cancleAction)
            self?.present(alertViewController, animated: true)
        }
        
        return cell
    }
}
