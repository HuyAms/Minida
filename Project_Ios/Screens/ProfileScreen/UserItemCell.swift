//
//  UserItemCell.swift
//  Project_Ios
//
//  Created by iosadmin on 18.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit
import Kingfisher

class UserItemCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(itemImgPath: String, itemName: String) {
        itemImage.loadImage(imgPath: itemImgPath)
        self.itemName.text = itemName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
