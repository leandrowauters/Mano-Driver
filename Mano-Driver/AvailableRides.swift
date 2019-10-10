//
//  AvailableRides.swift
//  
//
//  Created by Leandro Wauters on 10/10/19.
//

import UIKit
import GoogleMaps

class AvailableRides: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = LocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.getUserLocation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }
    func setupUI() {
        locationManager.setupMap(mapView: mapView)
    }
    

}
