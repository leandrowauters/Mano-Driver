//
//  DBService+Ride.swift
//  Mano
//
//  Created by Leandro Wauters on 9/3/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation
import FirebaseFirestore
extension DBService {
    
    
    public func fetchUserRides(completion: @escaping(Error?, [Ride]?) -> Void) -> ListenerRegistration {
        return DBService.firestoreDB.collection(RideCollectionKeys.collectionKey).whereField(RideCollectionKeys.driverIdKey, isEqualTo: AuthService.currentManoUser.userId).addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(error,nil)
            }
            if let snapshot = snapshot {
                let rides = snapshot.documents.map{Ride.init(dict: $0.data())}
                completion(nil, rides)
            }
        }
    }
    
    public func fetchAvailableRides(){
        DBService.firestoreDB.collection(RideCollectionKeys.collectionKey).whereField(RideCollectionKeys.rideStatusKey, isEqualTo: RideStatus.rideRequested.rawValue).addSnapshotListener { (snapshot, error) in
            if let error = error {
                self.rideFetchingDelegate?.errorFetchingRides(error: error)
            }
            
            if let snapshot = snapshot {
                let rides = snapshot.documents.map{Ride.init(dict: $0.data())}
                let filteredRides = rides.filter { (ride) -> Bool in
                    !ride.appointmentDate.stringToDate().dateExpired()
                }
                self.rideFetchingDelegate?.didFetchRides(rides: filteredRides)
            }
        }
    }
    
    public func changeRideStatus(ride: Ride, rideStatus: RideStatus) {
        DBService.firestoreDB.collection(RideCollectionKeys.collectionKey).document(ride.rideId).updateData([RideCollectionKeys.rideStatusKey : rideStatus.rawValue]) { [weak self]  error in
            if let error = error {
                self?.rideStatusChangeDelegate?.errorChangingStatus(error: error)
            } else {
                self?.rideStatusChangeDelegate?.didChangeStatus()
            }
            
        
        }
    }
}
