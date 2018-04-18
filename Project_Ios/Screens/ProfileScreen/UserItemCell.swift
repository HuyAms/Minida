//
//  UserItemCell.swift
//  Project_Ios
//
//  Created by iosadmin on 18.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit
import Kingfisher

class UserItemCell: UICollectionViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(item: Item) {
        itemImage.loadImage(imgPath: item.imgPath)
        self.priceLabel.text = String(item.price)
    }

}
