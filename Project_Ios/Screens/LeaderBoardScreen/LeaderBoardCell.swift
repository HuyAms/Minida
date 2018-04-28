//
//  LeaderBoardCell.swift
//  Project_Ios
//
//  Created by iosdev on 28.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

class LeaderBoardCell: UITableViewCell {
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var badgeIcon: UIImageView!
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var indexLbl: UILabel!
    @IBOutlet weak var numberRecycledItemLbl: UILabel!
    
    func config(index: Int, user: User) {
        userNameLbl.text = user.username
        indexLbl.text = String(index)
        numberRecycledItemLbl.text = "\(String(user.numberOfRecycledItems)) recycled items"
        if let avatarPath = user.avatarPath {
             avatarImgView.load(imgUrl: avatarPath)
        }
       badgeIcon.image = UIImage.getBadgeIcon(badge: Badge(badge: user.badge))
    }
}
