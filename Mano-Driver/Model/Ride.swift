//
//  Ride.swift
//  Mano
//
//  Created by Leandro Wauters on 9/1/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

enum RideStatus: String {
    case rideRequested
    case pickupAccepted
    case dropoffAccepted
    case changedToPickup
    case onPickup
    case changedToDropoff
    case onDropoff
    case changeToWaitingRequest
    case onWaitingToRequest
    case changedToReturnPickup
    case onPickupReturnRide
    case changedToReturnDropoff
    case onDropoffReturnRide
    case changedToIsOver
    case rideIsOver
    case rideCancelled
}
class Ride: Codable {
    var passanger: String
    var passangerId: String
    var rideId: String
    var pickupAddress: String
    var dropoffName: String
    var dropoffAddress: String
    var appointmentDate: String
    var pickupLat: Double
    var pickupLon: Double
    var dropoffLat: Double
    var dropoffLon: Double
    var acceptenceWasSeen: Bool
    var inProgress: Bool
    var duration: Int
    var distance: Double
    var dateRequested: String
    var driverName: String
    var driverId: String
    var driveProfileImage: String
    var driverMakerModel: String
    var originLat: Double
    var originLon: Double
    var licencePlate: String
    var carPicture: String
    var passangerKnowsDriverOnItsWay: Bool
    var passangerCell: String
    var driverCell: String
    var waitingForRequest: Bool
    var rideStatus: String
    var totalMiles: Double
    
    init(passanger: String, passangerId: String, rideId: String, pickupAddress: String,pickupLat: Double, pickupLon: Double, dropoffLat: Double, dropoffLon: Double ,dropoffAddress: String, dropoffName: String, appointmentDate: String,acceptenceWasSeen: Bool,inProgress: Bool, duration: Int, distance: Double, dateRequested: String, driverName: String, driverId: String, driveProfileImage: String, driverMakerModel: String, originLat: Double, originLon: Double, licencePlate: String, carPicture: String, passangerKnowsDriverOnItsWay: Bool, passangerCell: String, driverCell: String, waitingForRequest: Bool, rideStatus: String, totalMiles: Double) {
        self.passanger = passanger
        self.passangerId = passangerId
        self.rideId = rideId
        self.pickupAddress = pickupAddress
        self.dropoffAddress = dropoffAddress
        self.dropoffName = dropoffName
        self.appointmentDate = appointmentDate
        self.pickupLat = pickupLat
        self.pickupLon = pickupLon
        self.dropoffLat = dropoffLat
        self.dropoffLon = dropoffLon
        self.acceptenceWasSeen = acceptenceWasSeen
        self.inProgress = inProgress
        self.duration = duration
        self.distance = distance
        self.dateRequested = dateRequested
        self.driverName = driverName
        self.driverId = driverId
        self.driveProfileImage = driveProfileImage
        self.driverMakerModel = driverMakerModel
        self.originLat = originLat
        self.originLon = originLon
        self.licencePlate = licencePlate
        self.carPicture = carPicture
        self.passangerKnowsDriverOnItsWay = passangerKnowsDriverOnItsWay
        self.passangerCell = passangerCell
        self.driverCell = driverCell
        self.waitingForRequest = waitingForRequest
        self.rideStatus = rideStatus
        self.totalMiles = totalMiles
    }
    
    init(dict: [String: Any]) {
        self.passanger = dict[RideCollectionKeys.passangerName] as? String ?? ""
        self.passangerId = dict[RideCollectionKeys.passangerId] as? String ?? ""
        self.rideId = dict[RideCollectionKeys.rideIdKey] as? String ?? ""
        self.pickupAddress = dict[RideCollectionKeys.pickupAddressKey] as? String ?? ""
        self.dropoffAddress = dict[RideCollectionKeys.dropoffAddressKey] as? String ?? ""
        self.dropoffName = dict[RideCollectionKeys.dropoffNameKey] as? String ?? ""
        self.appointmentDate = dict[RideCollectionKeys.appoinmentDateKey] as? String ?? ""
        self.pickupLat = dict[RideCollectionKeys.pickupLatKey] as? Double ?? 0.0
        self.pickupLon = dict[RideCollectionKeys.pickupLonKey] as? Double ?? 0.0
        self.dropoffLat = dict[RideCollectionKeys.dropoffLatKey] as? Double ?? 0.0
        self.dropoffLon = dict[RideCollectionKeys.dropoffLonKey] as? Double ?? 0.0
        self.acceptenceWasSeen = dict[RideCollectionKeys.acceptenceWasSeenKey] as? Bool ?? false
        self.inProgress = dict[RideCollectionKeys.inProgressKey] as? Bool ?? false
        self.duration = dict[RideCollectionKeys.durationKey] as? Int ?? 0
        self.distance = dict[RideCollectionKeys.distanceKey] as? Double ?? 0.0
        self.dateRequested = dict[RideCollectionKeys.dateRequestedKey] as? String ?? ""
        self.driverName = dict[RideCollectionKeys.driverNameKey] as? String ?? ""
        self.driverId = dict[RideCollectionKeys.driverIdKey] as? String ?? ""
        self.driveProfileImage = dict[RideCollectionKeys.driverProfileImageKey] as? String ?? ""
        self.driverMakerModel = dict[RideCollectionKeys.driverMakerModelKey] as? String ?? ""
        self.originLat = dict[RideCollectionKeys.originLatKey] as? Double ?? 0.0
        self.originLon = dict[RideCollectionKeys.originLonKey] as? Double ?? 00
        self.licencePlate = dict[RideCollectionKeys.licencePlateKey] as? String ?? ""
        self.carPicture = dict[RideCollectionKeys.carPictureKey] as? String ?? ""
        self.passangerKnowsDriverOnItsWay = dict[RideCollectionKeys.passangerKnowsDriverOnItsWayKey] as? Bool ?? false
        self.passangerCell = dict[RideCollectionKeys.passangerCellKey] as? String ?? ""
        self.driverCell = dict[RideCollectionKeys.driverCellKey] as? String ?? ""
        self.waitingForRequest = dict[RideCollectionKeys.waitingForRequestKey] as? Bool ?? false
        self.rideStatus = dict[RideCollectionKeys.rideStatusKey] as? String ?? ""
        self.totalMiles = dict[RideCollectionKeys.totalMilesKey] as? Double ?? 0.0
    }
    
}
