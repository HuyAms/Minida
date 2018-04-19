//
//  HomeItemCell.swift
//  Project_Ios
//
//  Created by Dat Truong on 18/04/2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

import UIKit
import FoldingCell
import Kingfisher

class HomeItemCell: FoldingCell {
    
    @IBOutlet weak var smallItemImageView: UIImageView!
    @IBOutlet weak var smallItemNameLbl: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var smallPriceLbl: UILabel!
    @IBOutlet weak var detailNameLbl: UILabel!
    @IBOutlet weak var detailCategoryImgView: UIImageView!
    @IBOutlet weak var detailItemImgView: UIImageView!
    @IBOutlet weak var detailPriceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var sellerImgView: UIImageView!
    @IBOutlet weak var sellerNameLbl: UILabel!
    @IBOutlet weak var sellerRankLbl: UILabel!
    
    func config(itemHome: ItemHome) {
        smallItemNameLbl.text = itemHome.itemName
        smallPriceLbl.text = String(itemHome.price)
        detailNameLbl.text = itemHome.itemName
        detailPriceLbl.text = String(itemHome.price)
        let smallItemImgUrl = URL(string: itemHome.imgPath)
        let detailItemImgUrl = URL(string: itemHome.imgPath)
        // if no avatar is set, use default profile image
        let sellerImgUrl = URL(string: itemHome.seller.avatarPath ?? "")
        smallItemImageView.kf.setImage(with: smallItemImgUrl)
        detailItemImgView.kf.setImage(with: detailItemImgUrl)
        sellerImgView.kf.setImage(with: sellerImgUrl)
        //timeLbl.text = itemHome.time
        descriptionLbl.text = itemHome.description
        sellerNameLbl.text = itemHome.seller.username
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}
