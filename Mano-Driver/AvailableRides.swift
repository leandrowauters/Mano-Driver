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
    
    let auth = AuthService()
    let dbService = DBService()
    var userId: String?
    
    private var rides = [Ride]() {
        didSet {
            print("DidSet WORK!!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.getUserLocation()
        locationManager.delegate = self
        auth.autherserviceSignInDelegate = self
        auth.signIn(userId: userId!)
        dbService.rideFetchingDelegate = self
    }
    
    
    func setupUI() {
        locationManager.setupMap(mapView: mapView)
    }
    
    func didUpdateLocation(_: Bool) {
       setupUI()
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
