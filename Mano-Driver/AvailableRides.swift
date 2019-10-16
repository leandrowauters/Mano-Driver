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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let locationManager = LocationManager()
    weak var locationManagerDelegate: LocationManagerDelegate?
    
    private var rides = [Ride]()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.getUserLocation()
        locationManager.delegate = self
    }
    
    
    func setupUI() {
        locationManager.setupMap(mapView: mapView)
    }
    
    func didUpdateLocation(_: Bool) {
       setupUI()
    }
    
    func fecthRides() {
        DBService.fetchUserRides { [weak self] error, rides in
            if let error = error {
                self?.showAlert(title: "Error fetching rides", message: error.localizedDescription)
            }
            
            if let rides = rides {
                self?.rides = rides
            }
        }
    }

}
