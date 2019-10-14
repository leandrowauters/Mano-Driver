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
    func didUpdateLocation(_: Bool)
}
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private var locationManager = CLLocationManager()
    public var currentLocation = CLLocation()
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
    
    func setupMap(mapView: GMSMapView){
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        let position = currentLocation.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 14.0)
        mapView.animate(to: camera)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()

        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {return}
        self.currentLocation = currentLocation
        delegate?.didUpdateLocation(true)
//        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 11.0)
        locationManager.stopUpdatingLocation()
    }
}
