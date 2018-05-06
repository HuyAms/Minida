//
//  PaymentVC.swift
//  Project_Ios
//
//  Created by iosadmin on 21.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit
import Stripe

protocol PaymentVCProtocol: class {
    
    func onGetMeSuccess(user: User)
    
    func onGetMeError(error: AppError)
    
    func showLoading()
    
    func hideLoading()
    
}

class PaymentVC: UIViewController, PaymentVCProtocol {

    var presenter: PaymentPresenterProtocol?
    
    let paymentEuroOptions = [5, 10, 25, 50, 100, 200]
    
  
    

    // Controllers
    private let customerContext: STPCustomerContext
    private let paymentContext: STPPaymentContext
    private let paymentService: PaymentService
    
    private var price = 0 {
        didSet {
            // Forward value to payment context
            paymentContext.paymentAmount = price
        }
    }
    
    
    //MARK: Outlet
    @IBOutlet weak var addCardBtn: UIButton?
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pointNumberLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var instructLbl: UILabel!
    @IBOutlet weak var pointLbl: UILabel!
    
    
    // MARK: Init
    required init?(coder aDecoder: NSCoder) {

        paymentService = PaymentService()
        customerContext = STPCustomerContext(keyProvider: paymentService)
        paymentContext = STPPaymentContext(customerContext: customerContext)
        
        super.init(coder: aDecoder)
        
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.dataSource = self
        tableView.delegate = self
        presenter = PaymentPresenter(view: self)
        
        reloadAddCardButtonContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getMe()
    }

    //MARK: Action
    @IBAction func addCardBtnWasPressed(_ sender: Any) {
        presentPaymentMethodsViewController()
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helpers
    private func presentPaymentMethodsViewController() {
        guard !STPPaymentConfiguration.shared().publishableKey.isEmpty else {
            print("Invalid publishableKey")
            return
        }
        paymentContext.presentPaymentMethodsViewController()
    }
    
    private func reloadAddCardButtonContent() {
        if let selectedPaymentMethod = paymentContext.selectedPaymentMethod  {
            addCardBtn?.setImage(selectedPaymentMethod.image, for: .normal)
            addCardBtn?.setTitle(selectedPaymentMethod.label, for: .normal)
        } else {
             addCardBtn?.setTitle("Add Card".localized, for: .normal)
        }
    }
    
    func showLoading() {
        showLoadingIndicator()
    }
    
    func hideLoading() {
        hideLoadingIndicator()
    }
    
    func onGetMeSuccess(user: User) {
        userNameLbl.text = user.username
        if let point = user.point {
            pointNumberLbl.text = String(point)
        }
    }
    
    func onGetMeError(error: AppError) {
        showError(message: error.description)
    }
    
    //MARK: Helper
    func setupUI() {
        titleLbl.text = "Point Purchase".localized
        nameLbl.text = "Name:".localized
        pointLbl.text = "Point:".localized
        userNameLbl.text = "username".localized
        instructLbl.text = "Please select your payment method".localized
        
    }

}

extension PaymentVC: STPPaymentContextDelegate {
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        paymentContext.retryLoading()
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        reloadAddCardButtonContent()
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
        let source = paymentResult.source.stripeID
        
        presenter?.buyPoint(amount: price, source: source, completion: { [weak self](user, error) in
            guard error == nil else {
                completion(error)
                return
            }
            
            guard let user = user else {
                return
            }
            
            guard let point = user.point else {
                return
            }
            
            self?.showSuccess(title: "Success", message: "You now have \(String(describing: point)) points", closeBtnText: "OK")
            
            completion(nil)
        })
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        switch status {
        case .success:
            print("success")
        case .error:
            if let error = error as? AppError {
                showError(message: error.description)
            } else {
                showError(message: "Could not request point")
            }
        case .userCancellation:
            return
        }
    }
}

extension PaymentVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentEuroOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let euro = paymentEuroOptions[indexPath.row]
        let point = euro * KEY.CURRENT_EXCHANGE
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppTableCell.paymentCell.identifier, for: indexPath) as? PaymentCell else {
            return UITableViewCell()
        }
        cell.config(euro: euro)
        
        cell.onButtonTapped = { [weak self] () in
            let alertViewController = UIAlertController(title: "Payment", message: "\(point) points cost you \(euro) €", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "Pay Now", style: .default) { (action) in
                self?.price = euro
                self?.paymentContext.requestPayment()
            }
            let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertViewController.addAction(okAction)
            alertViewController.addAction(cancleAction)
            self?.present(alertViewController, animated: true)
        }
        
        return cell
    }

}


