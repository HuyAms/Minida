//
//  NotificationCell.swift
//  Project_Ios
//
//  Created by iosdev on 26.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

enum NotiType {
    case meSeller
    case meBuyer
    
    init(notiType: Int) {
        switch(notiType) {
        case 1:
            self = .meBuyer
        case 2:
            self = .meSeller
        default:
            self = .meBuyer
        }
    }
}

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var notiImageView: UIImageView!
    @IBOutlet weak var notiDescriptionLbl: UILabel!
    @IBOutlet weak var notiTimeLbl: UILabel!
    
    func config(notification: Notification) {
        let notiType = NotiType(notiType: notification.notiType)
        switch notiType {
        case .meBuyer:
            notiImageView.load(imgUrl: notification.item.imgPath)
            let boughtItem = notification.item.itemName
            let sellerName = notification.notiBody.username
            notiDescriptionLbl.text = "You have bought \(boughtItem) from \(sellerName)"
        case .meSeller:
            if let buyerAvaImg = notification.notiBody.avatarPath {
                notiImageView.load(imgUrl: buyerAvaImg)
            }
            let soldItem = notification.item.itemName
            let buyerName = notification.notiBody.username
            notiDescriptionLbl.text = "You have sold \(soldItem) to \(buyerName)"
        }
        
        let time = AppUtil.shared.formantTimeStamp(isoDate: notification.time)
        notiTimeLbl.text = time
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
}

