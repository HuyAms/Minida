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

class HomeItemCell: FoldingCell {
    
    @IBOutlet weak var smallItemImageView: UIImageView!
    @IBOutlet weak var smallItemNameLbl: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var smallPriceLbl: UILabel!
    @IBOutlet weak var detailNameLbl: UILabel!
    @IBOutlet weak var priceIconImgView: UIImageView!
    @IBOutlet weak var detailCategoryImgView: UIImageView!
    @IBOutlet weak var detailItemImgView: UIImageView!
    @IBOutlet weak var detailPriceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var sellerImgView: UIImageView!
    @IBOutlet weak var sellerNameLbl: UILabel!
    @IBOutlet weak var sellerRankLbl: UILabel!
    
    var onBuyButtonTapped: (() -> Void)? = nil
    var onImgButtonTapped: (() -> Void)? = nil
    
    func config(itemHome: ItemDetail) {
        smallItemNameLbl.text = itemHome.itemName
        detailNameLbl.text = itemHome.itemName
        
        smallItemImageView.load(imgUrl: itemHome.imgPath)
        detailItemImgView.load(imgUrl: itemHome.imgPath)
        
        if itemHome.seller.avatarPath != nil {
            sellerImgView.load(imgUrl: itemHome.seller.avatarPath!)
        }
        
        let price = itemHome.price
        if price == 0 {
            detailPriceLbl.text = "FREE"
            smallPriceLbl.text = "FREE"
        } else {
            detailPriceLbl.text = String(itemHome.price)
            smallPriceLbl.text = String(itemHome.price)
        }

        //timeLbl.text = itemHome.time
        descriptionLbl.text = itemHome.description
        sellerNameLbl.text = itemHome.seller.username
        
        let category = Category(rawValue: itemHome.category) ?? Category.others
        switch category {
        case .accessories:
            categoryImageView.image = UIImage.getAccessoriesIconBlack()
            detailCategoryImgView.image = UIImage.getAccessoriesIconWhite()
        case .clothing:
            categoryImageView.image = UIImage.getClothingIconBlack()
            detailCategoryImgView.image = UIImage.getClothingIconWhite()
        case .homewares:
            categoryImageView.image = UIImage.getHomewaresIconBlack()
            detailCategoryImgView.image = UIImage.getHomewaresIconWhite()
        case .vehicles:
            categoryImageView.image = UIImage.getVehiclesIconBlack()
            detailCategoryImgView.image = UIImage.getVehiclesIconWhite()
        case .devices:
            categoryImageView.image = UIImage.getDevicesIconBlack()
            detailCategoryImgView.image = UIImage.getDevicesIconWhite()
        default:
            categoryImageView.image = UIImage.getOthersIconBlack()
            detailCategoryImgView.image = UIImage.getOthersIconWhite()
        }
    }
    
    
    @IBAction func buyButtonWasPressed(_ sender: UIButton) {
        if let onBuyButtonTapped = self.onBuyButtonTapped {
            onBuyButtonTapped()
        }
    }
    
    @IBAction func imgButtonWasPressed(_ sender: Any) {
        if let onImgButtonTapped = self.onImgButtonTapped {
            onImgButtonTapped()
        }
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
