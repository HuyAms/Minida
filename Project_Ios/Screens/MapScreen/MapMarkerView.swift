//
//  MapView.swift
//  Project_Ios
//
//  Created by Huy Trinh on 11.4.2018.
//  Copyright © 2018 Huy Trinh. All rights reserved.
//

import MapKit

class MapMarkerView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let mapItem = newValue as? MapItem else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            let mapButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
            mapButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControlState())
            rightCalloutAccessoryView = mapButton
            
            image = UIImage.getMapAnnotationImage()
            let detailLable = UILabel()
            detailLable.numberOfLines = 0
            detailLable.font = detailLable.font.withSize(12)
            detailLable.text = mapItem.subtitle
            detailCalloutAccessoryView = detailLable
            
        }
    }
}
