//
//  LocationManager.swift
//  Mano-Driver
//
//  Created by Leandro Wauters on 10/10/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation
import GoogleMaps

protocol LocationManagerDelegate: AnyObject {
    func didGetLocation(location: CLLocationCoordinate2D)
}
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private var locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?

    func getUserLocation() {
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            // we need to say how accurate the data should be
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // closest location accuracy
            locationManager.startUpdatingLocation()
            
        } else {
            locationManager.requestWhenInUseAuthorization()// this is only while the app is unlocked
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
    }
    

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()

        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {return}
        delegate?.didGetLocation(location: currentLocation.coordinate)
//        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 11.0)
        locationManager.stopUpdatingLocation()
    }
}
