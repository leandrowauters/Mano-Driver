//
//  DBService.swift
//  Mano
//
//  Created by Leandro Wauters on 9/1/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

import Foundation
import FirebaseFirestore
import Firebase

protocol RideFetchingDelegate: AnyObject {
    func didFetchRides(rides: [Ride])
    func errorFetchingRides(error: Error)
}

protocol RideStatusChangeDelegate: AnyObject {
    func didChangeStatus()
    func errorChangingStatus(error: Error)
}


final class DBService {
    
    weak var rideFetchingDelegate: RideFetchingDelegate?
    weak var rideStatusChangeDelegate: RideStatusChangeDelegate?
    
    public static var firestoreDB: Firestore = {
        let db = Firestore.firestore()
        let settings = db.settings
        db.settings = settings
        return db
    }()
}
