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
    
    
    static public func fetchUserRides(completion: @escaping(Error?, [Ride]?) -> Void) -> ListenerRegistration {
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
    
    static public func fetchAvailableRides(completion: @escaping(Error?, [Ride]?) -> Void) -> ListenerRegistration {
        return firestoreDB.collection(RideCollectionKeys.collectionKey).whereField(RideCollectionKeys.rideStatusKey, isEqualTo: RideStatus.rideRequested).addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(error, nil)
            }
            
            if let snapshot = snapshot {
                let rides = snapshot.documents.map{Ride.init(dict: $0.data())}
                let filteredRides = rides.filter { (ride) -> Bool in
                    !ride.appointmentDate.stringToDate().dateExpired()
                }
            }
        }
    }
}
