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
        pointLbl.text = String("Add \(euro * KEY.CURRENT_EXCHANGE) points")
        euroLbl.text = String("\(euro) €")
    }
    
    @IBAction func addBtnWasPressed(_ sender: Any) {
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
}
