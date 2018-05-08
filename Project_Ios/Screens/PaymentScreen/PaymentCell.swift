//
//  PaymentCell.swift
//  Project_Ios
//
//  Created by iosadmin on 22.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

class PaymentCell: UITableViewCell {
    var onButtonTapped : (() -> Void)? = nil
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var euroLbl: UILabel!
    @IBOutlet weak var pointLbl: UILabel!
    

    func config(euro: Int) {
        let formatString = NSLocalizedString("Add %d points",
                                             comment: "")
        pointLbl.text = "Add %d points".localized(arguments: euro * KEY.CURRENT_EXCHANGE)
        euroLbl.text = String("\(euro) €")
    }
    
    override func awakeFromNib() {
        addBtn.setTitle("Add".localized, for: .normal)
    }
    
    @IBAction func addBtnWasPressed(_ sender: Any) {
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
}
