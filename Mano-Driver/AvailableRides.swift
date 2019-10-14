//
//  AvailableRides.swift
//  
//
//  Created by Leandro Wauters on 10/10/19.
//

import UIKit
import GoogleMaps

class AvailableRides: UIViewController, LocationManagerDelegate {

    

    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = LocationManager()
    weak var locationManagerDelegate: LocationManagerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.getUserLocation()
        locationManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func setupUI() {
        locationManager.setupMap(mapView: mapView)
    }
    
    func didUpdateLocation(_: Bool) {
       setupUI()
    }

}
