//
//  DBService+ManoUser.swift
//  Mano
//
//  Created by Leandro Wauters on 9/1/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

extension DBService {
    
    
    
    public func createUser(manoUser: ManoUserDriver, completion: @escaping (Error?) -> Void) {
        DBService.firestoreDB.collection(ManoUserDriverCollectionKeys.collectionKey).document(manoUser.userId).setData(
            [ManoUserDriverCollectionKeys.firstNameKey : manoUser.firstName,
             ManoUserDriverCollectionKeys.lastNameKey : manoUser.lastName,
             ManoUserDriverCollectionKeys.fullNameKey : manoUser.fullName,
             ManoUserDriverCollectionKeys.typeOfUserKey : manoUser.typeOfUser,
             ManoUserDriverCollectionKeys.userIdKey : manoUser.userId,
             ManoUserDriverCollectionKeys.cellPhoneKey : manoUser.cellPhone!,
             ManoUserDriverCollectionKeys.homeAddressKey : manoUser.homeAdress!,
             ManoUserDriverCollectionKeys.homeLatKey : manoUser.homeLat!,
             ManoUserDriverCollectionKeys.homeLonKey : manoUser.homeLon!
                
                
        ]) { (error) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    public func updateBio(userId: String, bioText: String, completion: @escaping (Error?) -> Void) {
        DBService.firestoreDB.collection(ManoUserDriverCollectionKeys.collectionKey).document(userId).updateData([ManoUserDriverCollectionKeys.bioKey : bioText]) { (error) in
            if let error = error {
                completion(error)
            } else {
                print("Bio updated")
            }
        }
    }

    public func fetchManoUser(userId: String, completion: @escaping (Error?, ManoUserDriver?) -> Void) {
        DBService.firestoreDB
            .collection(ManoUserDriverCollectionKeys.collectionKey)
            .whereField(ManoUserDriverCollectionKeys.userIdKey, isEqualTo: userId)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(error, nil)
                } else if let snapshot = snapshot?.documents.first {
                    let manoUser = ManoUserDriver.init(dict: snapshot.data())
                    completion(nil, manoUser)
                } else {
                    completion(nil, nil)
                }
        }
    }
    
    public func deleteAccount(user: ManoUserDriver, completion: @escaping (Error?) -> Void) {
        DBService.firestoreDB
            .collection(ManoUserDriverCollectionKeys.collectionKey)
            .document(user.userId)
            .delete { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
        }
    }
}
