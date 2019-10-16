//
//  ManoUser.swift
//  Mano
//
//  Created by Leandro Wauters on 9/1/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//


import Foundation

class ManoUserDriver: Codable {
    var firstName: String
    var lastName: String
    var fullName: String
    var homeAdress: String?
    var homeLat: Double?
    var homeLon: Double?
    var profileImage: String?
    var carMakerModel: String?
    var bio: String?
    var typeOfUser: String //ENUM TYPE OF USER
    var regulars: [String]?
    var joinedDate: String
    var userId: String
    var numberOfRides: Int?
    var numberOfMiles: Double?
    var licencePlate: String?
    var carImage: String?
    var userImage: String?
    var cellPhone: String?
    var rides: [String]?
    
    init(firstName: String, lastName: String, fullName: String, homeAdress: String?,homeLat: Double?,homeLon: Double?, profileImage: String?, carMakerModel: String?, bio: String?, typeOfUser: String, regulars: [String]?, joinedDate: String, userId: String, numberOfRides: Int?, numberOfMiles: Double?, licencePlate: String?, carImage: String?,userImage: String?,cellPhone: String?, rides: [String]?) {
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = fullName
        self.homeAdress = homeAdress
        self.profileImage = profileImage
        self.homeLat = homeLat
        self.homeLon = homeLon
        self.carMakerModel = carMakerModel
        self.bio = bio
        self.typeOfUser = typeOfUser
        self.regulars = regulars
        self.joinedDate = joinedDate
        self.userId = userId
        self.numberOfRides = numberOfRides
        self.numberOfMiles = numberOfMiles
        self.licencePlate = licencePlate
        self.carImage = carImage
        self.userImage = userImage
        self.cellPhone = cellPhone
        self.rides = rides
    }
    
    init(dict: [String: Any]) {
        self.firstName = dict[ManoUserDriverCollectionKeys.firstNameKey] as? String ?? ""
        self.lastName = dict[ManoUserDriverCollectionKeys.lastNameKey] as? String ?? ""
        self.fullName = dict[ManoUserDriverCollectionKeys.fullNameKey] as? String ?? ""
        self.homeAdress = dict[ManoUserDriverCollectionKeys.homeAddressKey] as? String ?? ""
        self.homeLon = dict[ManoUserDriverCollectionKeys.homeLonKey] as? Double ?? 0.0
        self.homeLat = dict[ManoUserDriverCollectionKeys.homeLatKey] as? Double ?? 0.0
        self.profileImage = dict[ManoUserDriverCollectionKeys.profileImageKey] as? String ?? ""
        self.carMakerModel = dict[ManoUserDriverCollectionKeys.carMakerModelKey] as? String
        self.bio = dict[ManoUserDriverCollectionKeys.bioKey] as? String ?? ""
        self.typeOfUser = dict[ManoUserDriverCollectionKeys.typeOfUserKey] as? String ?? ""
        self.regulars = dict[ManoUserDriverCollectionKeys.regularsKey] as? [String]
        self.joinedDate = dict[ManoUserDriverCollectionKeys.joinedDateKey] as? String ?? ""
        self.userId = dict[ManoUserDriverCollectionKeys.userIdKey] as? String ?? ""
        self.numberOfRides = dict[ManoUserDriverCollectionKeys.numberOfRides] as? Int ?? 0
        self.numberOfMiles = dict[ManoUserDriverCollectionKeys.numberOfMiles] as? Double ?? 0.0
        self.licencePlate = dict[ManoUserDriverCollectionKeys.licencePlateKey] as? String ?? ""
        self.carImage = dict[ManoUserDriverCollectionKeys.carImage] as? String ?? ""
        self.userImage = dict[ManoUserDriverCollectionKeys.userImage] as? String ?? ""
        self.cellPhone = dict[ManoUserDriverCollectionKeys.cellPhoneKey] as? String ?? ""
        self.rides = dict[ManoUserDriverCollectionKeys.ridesKey] as? [String]
    }
    
}
