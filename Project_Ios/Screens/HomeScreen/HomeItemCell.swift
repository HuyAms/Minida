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
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var rankIcon: UIImageView!
    
    var onBuyButtonTapped: (() -> Void)? = nil
    var onImgButtonTapped: (() -> Void)? = nil
    var onAvaTapped: (() -> Void)? = nil
    var onDeleteTapped: (() -> Void)? = nil
    var sellerId: String?

    
    func config(itemHome: ItemDetail) {
        sellerId = itemHome.seller._id
        deleteBtn.isHidden = !isMyItem()
        smallItemNameLbl.text = itemHome.itemName
        detailNameLbl.text = itemHome.itemName
        sellerRankLbl.text = itemHome.seller.badge
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
        

        rankIcon.image = UIImage.getBadgeIcon(badge: Badge(badge: itemHome.seller.badge))
        timeLbl.text = AppUtil.shared.formantTimeStamp(isoDate: itemHome.time)
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
        
        setUpTapGesture()
        
    }
    
    override func prepareForReuse() {
        deleteBtn.isHidden = !isMyItem()
    }
    
    //MARK: Helper
    
    func isMyItem() -> Bool {
        if let myId = KeyChainUtil.share.getUserId(), let sellerId = self.sellerId {
            return myId == sellerId
        } else {
            return false
        }
    }
    
    func setUpTapGesture() {
        let imgTapGesture = UITapGestureRecognizer(target: self
            , action: #selector(HomeItemCell.imgTapHandler(_:)))
        smallItemImageView.addGestureRecognizer(imgTapGesture)
        
        let avaTabGesture = UITapGestureRecognizer(target: self
            , action: #selector(HomeItemCell.avaTapHandler(_:)))
        sellerImgView.addGestureRecognizer(avaTabGesture)
    }
    
    @objc private func imgTapHandler(_ sender: UITapGestureRecognizer) {
        if let onImgButtonTapped = self.onImgButtonTapped {
            onImgButtonTapped()
        }
    }
    
    @objc private func avaTapHandler(_ sender: UITapGestureRecognizer) {
        if let onAvaTapped = self.onAvaTapped {
            onAvaTapped()
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
    
    @IBAction func deleteBtnWasPressed(_ sender: Any) {
        if let onDeleteTapped = self.onDeleteTapped {
            onDeleteTapped()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }

}
