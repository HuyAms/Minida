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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        
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
