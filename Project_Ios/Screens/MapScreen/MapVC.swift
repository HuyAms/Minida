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
    
    func onGetMyLocationSuccess(lat: Double, lng: Double)
    
    func onGetMyLocationError()
    
}

class MapVC: UIViewController , MapViewProtocol {
    
    //MARK: Outlet
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var myLocationBtn: UIButton!
    
    var presenter: MapPresenterProtocol?
    
    
    let regionRadius: CLLocationDistance = 8000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        presenter = MapPresenter(view: self)
        
        presenter?.loadCenterInfo()
        
        setUpLocation()
      
    }
    
    //MARK: ACTION
    @IBAction func myLocationBtnWasPressed(_ sender: Any) {
        presenter?.getMyLocation()
    }
    
    func setUpLocation() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
          mapView.showsUserLocation = true
        }
        
        presenter?.getMyLocation()
    }
    
    func onLoadDataSuccess(centerList: [RecycleCenter]) {
        var mapItems = [MapItem]()
        mapView.register(MapMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        centerList.forEach { (center) in
            let centerLocation = CLLocationCoordinate2D(latitude: center.lat, longitude: center.lng)
            let mapItem = MapItem(title: center.name, address: center.address, coordinate: centerLocation)
            mapItems.append(mapItem)
        }
        
        mapView.addAnnotations(mapItems)
    }
    
    func onLoadDataError(error: AppError) {
        showError(message: error.description)
    }
    
    func onGetMyLocationSuccess(lat: Double, lng: Double) {
        let myLocation = CLLocation(latitude: lat, longitude: lng)
        centerMapOnLocation(location: myLocation)
    }
    
    func onGetMyLocationError() {
        let initialLocation = CLLocation(latitude: 60.192059, longitude: 24.945831) //Helsinki
        centerMapOnLocation(location: initialLocation)
    }
    
    func showLoading() {
        showLoadingIndicator()
    }
    
    func hideLoading() {
        hideLoadingIndicator()
    }
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! MapItem
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        let alertViewController = UIAlertController(title: "Direction", message: "Open Apple Maps to get direction", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            location.mapItem().openInMaps(launchOptions: launchOptions)
        }
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertViewController.addAction(okAction)
        alertViewController.addAction(cancleAction)
        self.present(alertViewController, animated: true)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

