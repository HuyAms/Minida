//
//  ProfileCell.swift
//  Project_Ios
//
//  Created by iosadmin on 23.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileCell: UICollectionViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var itemImage: UIImageView!
    
    //MARK: Actions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(item: Item) {
        itemImage.load(imgUrl: item.imgPath)
    }
    
}
