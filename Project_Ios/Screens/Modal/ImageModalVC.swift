//
//  ImageModalVC.swift
//  Project_Ios
//
//  Created by iosdev on 25.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

class ImageModalVC: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
     var imgPath: String?
    
    func config(imgPath: String) {
        self.imgPath = imgPath
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGuesture = UITapGestureRecognizer(target: self
            , action: #selector(ImageModalVC.backGroundViewTapHandler(_:)))
        backgroundView.addGestureRecognizer(tapGuesture)
        
        if let imgPath = self.imgPath {
             imageView.load(imgUrl: imgPath)
        }
     
    }
    
    @IBAction func clossBtnWasPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func backGroundViewTapHandler(_ sender: UITapGestureRecognizer) {
           dismiss(animated: false, completion: nil)
    }
}
