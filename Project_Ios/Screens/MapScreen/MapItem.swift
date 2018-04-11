//
//  MapItem.swift
//  Project_Ios
//
//  Created by Huy Trinh on 11.4.2018.
//  Copyright © 2018 Huy Trinh. All rights reserved.
//

import MapKit
import Contacts

class MapItem: NSObject, MKAnnotation {
    let title: String?
    let address: String
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.address = address
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return address
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
   
}
