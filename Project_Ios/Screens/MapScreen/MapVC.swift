//
//  FirstViewController.swift
//  Project_Ios
//
//  Created by Huy Trinh on 04/04/2018.
//  Copyright © 2018 Huy Trinh. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewProtocol: class {
    
    func onLoadDataSuccess(centerList: [RecycleCenter])
    
    func onLoadDataError(error: AppError)
    
    func showLoading()
    
    func hideLoading()
    
}

class MapVC: UIViewController , MapViewProtocol {
    
    //MARK: Outlet
    @IBOutlet weak var mapView: MKMapView!
    
    var presenter: MapPresenterProtocol?
    
    let initialLocation = CLLocation(latitude: 60.192059, longitude: 24.945831) //Helsinki
    let regionRadius: CLLocationDistance = 8000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        presenter = MapPresenter(view: self)
        
        presenter?.loadCenterInfo()
        
        centerMapOnLocation(location: initialLocation)
      
    }
    
    func onLoadDataSuccess(centerList: [RecycleCenter]) {
        
        var mapItems = [MapItem]()
        mapView.register(MapMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        centerList.forEach { (center) in
            let centerLocation = CLLocationCoordinate2D(latitude: center.lat, longitude: center.lng)
            let mapItem = MapItem(title: center.name, address: center.address, coordinate: centerLocation)
            mapItems.append(mapItem)
        }
        
        mapItems.forEach { (item) in
            print(item.title!)
        }
        
        mapView.addAnnotations(mapItems)
    }
    
    func onLoadDataError(error: AppError) {
        
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! MapItem
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

