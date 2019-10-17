//
//  GMSMapView+Extension.swift
//  Mano-Driver
//
//  Created by Leandro Wauters on 10/16/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation
import GoogleMaps



extension GMSMapView {
    func addMarkers(rides: [Ride]) {
        var index = 0
        clear()
        for ride in rides {
            let location = CLLocationCoordinate2D(latitude: ride.pickupLat, longitude: ride.pickupLon)
            let marker = GMSMarker()
            marker.position = location
            marker.title = index.description
            let appointmentDate = ride.appointmentDate.stringToDate()
            if appointmentDate.isTodayOrTomorrow() {
                marker.icon = GMSMarker.markerImage(with: #colorLiteral(red: 0.995932281, green: 0.2765177786, blue: 0.3620784283, alpha: 1))
            }
            marker.map = self
            print("LAT: \(ride.pickupLat) , LON: \(ride.pickupLon)")
            index += 1
        }
    }
    
    func setupMap(position: CLLocationCoordinate2D, zoom: Double){
        settings.compassButton = true
        settings.myLocationButton = true
        isMyLocationEnabled = true
        let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: Float(zoom))
        animate(to: camera)
    }
    
    
}
