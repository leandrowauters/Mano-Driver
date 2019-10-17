//
//  AvailableRides.swift
//  
//
//  Created by Leandro Wauters on 10/10/19.
//

import UIKit
import GoogleMaps

class AvailableRides: UIViewController, LocationManagerDelegate {
    func didGetLocation(location: CLLocationCoordinate2D) {
                mapView.setupMap(position: location, zoom: 12)
    }
    

    

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapDetailView: UIView!
    @IBOutlet weak var passangerName: UILabel!
    @IBOutlet weak var passangerAddress: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let locationManager = LocationManager()
    private var selectedRide: Ride?
    weak var locationManagerDelegate: LocationManagerDelegate?
    
    let auth = AuthService()
    let dbService = DBService()
    var userId: String?
    
    private var rides = [Ride]() {
        didSet {
            DispatchQueue.main.async {
                self.mapView.addMarkers(rides: self.rides)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.getUserLocation()
        locationManager.delegate = self
        auth.autherserviceSignInDelegate = self
        auth.signIn(userId: userId!)
        dbService.rideFetchingDelegate = self
        mapView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func moreButtonPressed(_ sender: Any) {
        
    }
    

    


}

extension AvailableRides: AuthServiceSignInDelegate {
    func didSignIn(manoUser: ManoUserDriver) {
        dbService.fetchAvailableRides()
    }
    
    func didSignInError(error: Error) {
        activityIndicator.stopAnimating()
        showAlert(title: "Error signing in", message: error.localizedDescription)
    }
    
    
}

extension AvailableRides: RideFetchingDelegate {
    func didFetchRides(rides: [Ride]) {
        self.rides = rides
        activityIndicator.stopAnimating()
    }
    
    func errorFetchingRides(error: Error) {
        
    }
    
    
}

extension AvailableRides: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.setupMap(position: marker.position, zoom: 14)
        let index = Int(marker.title!)!
        let selectedRide = rides[index]
        passangerAddress.text = selectedRide.pickupAddress
        passangerName.text = selectedRide.passanger
        mapDetailView.isHidden = false
        
        return true
    }
}
