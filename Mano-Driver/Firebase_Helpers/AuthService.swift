//
//  AuthService.swift
//  Mano
//
//  Created by Leandro Wauters on 9/1/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

protocol AuthServiceCreateNewAccountDelegate: AnyObject {
    func didRecieveErrorCreatingAccount(_ authservice: AuthService, error: Error)
    func didCreateNewAccount(_ authservice: AuthService, user: ManoUserDriver)
}

protocol AuthServiceExistingAccountDelegate: AnyObject {
    func didRecieveErrorSigningToExistingAccount(_ authservice: AuthService, error: Error)
    func didSignInToExistingAccount(_ authservice: AuthService, user: User)
}

protocol AuthServiceSignOutDelegate: AnyObject {
    func didSignOutWithError(_ authservice: AuthService, error: Error)
    func didSignOut(_ authservice: AuthService)
}

protocol AuthServiceUpdateAccountDelegate: AnyObject {
    func didUpdateAccount()
    func didRecieveErrorUpdatingAccount(error: Error)
}

protocol AuthServiceSignInDelegate: AnyObject {
    func didSignIn()
    func didSignInError(error: Error)
}

final class AuthService {
    weak var authserviceCreateNewAccountDelegate: AuthServiceCreateNewAccountDelegate?
    weak var authserviceExistingAccountDelegate: AuthServiceExistingAccountDelegate?
    weak var authserviceSignOutDelegate: AuthServiceSignOutDelegate?
    weak var authserviceUpdateAccountDelegate: AuthServiceUpdateAccountDelegate?
    weak var autherserviceSignInDelegage: AuthServiceSignInDelegate?
    
    static public var currentManoUser: ManoUserDriver!
    //Fetch user and assign to currentManoUser
    public func signIn() {
        
    }
    public func createAccount(firstName: String, lastName: String, password: String, email: String, typeOfUser: String, phone: String, homeAddress: String, homeLat: Double, homeLon: Double) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                self.authserviceCreateNewAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
                return
            }
            else if let authDataResult = authDataResult {
                let joinedDate = Date().dateDescription
                let manoUser = ManoUserDriver(firstName: firstName, lastName: lastName, fullName: ((firstName ) + " " + (lastName )).trimmingCharacters(in: .whitespacesAndNewlines), homeAdress: homeAddress, homeLat: homeLat, homeLon: homeLon, profileImage: nil, carMakerModel: nil, bio: nil, typeOfUser: typeOfUser, regulars: nil, joinedDate: joinedDate, userId: authDataResult.user.uid, numberOfRides: nil, numberOfMiles:  nil, licencePlate: nil, carImage: nil,userImage: nil, cellPhone: phone, rides: nil)
                DBService.createUser(manoUser: manoUser, completion: { (error) in
                    if let error = error {
                        self.authserviceCreateNewAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
                    }
                    self.authserviceCreateNewAccountDelegate?.didCreateNewAccount(self, user: manoUser)
                })
            }
        }
        
    }
    
   public func updateCarInfo(userId: String,make: String, model: String,state: String, plate: String,frontImage: String, backImage: String) {
        DBService.firestoreDB.collection(ManoUserDriverCollectionKeys.collectionKey).document(userId).updateData([ManoUserDriverCollectionKeys.carMakerModelKey : "\(make) \(model)",
                                                                                                            ManoUserDriverCollectionKeys.state : state, ManoUserDriverCollectionKeys.licencePlateKey : plate, ManoUserDriverCollectionKeys.carImage : frontImage, ManoUserDriverCollectionKeys.userImage : backImage]) { (error) in
                                                  
                                                                                        if let error = error {
                                                                                            self.authserviceUpdateAccountDelegate?.didRecieveErrorUpdatingAccount(error: error)
                                                                                        } else {
                                                                                            self.authserviceUpdateAccountDelegate?.didUpdateAccount()
                                                                                                                }
        }
    }
    public func createGoogleAccountUser(firstName: String, lastName: String, email: String, typeOfUser: String, phone: String, homeAddress: String, userId: String, homeLat: Double, homeLon: Double) {
        let joinedDate = Date().dateDescription
        let manoUser = ManoUserDriver(firstName: firstName, lastName: lastName, fullName: ((firstName ) + " " + (lastName )).trimmingCharacters(in: .whitespacesAndNewlines), homeAdress: homeAddress, homeLat: homeLat, homeLon: homeLon, profileImage: nil, carMakerModel: nil, bio: nil, typeOfUser: typeOfUser, regulars: nil, joinedDate: joinedDate, userId: userId, numberOfRides: nil, numberOfMiles:  nil, licencePlate: nil, carImage: nil, userImage: nil ,cellPhone: phone, rides: nil)
        DBService.createUser(manoUser: manoUser, completion: { (error) in
            if let error = error {
                self.authserviceCreateNewAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
            }
            self.authserviceCreateNewAccountDelegate?.didCreateNewAccount(self, user: manoUser)
        })
    }
    
    public func googleUserCreateAccount(manoUser: ManoUserDriver) {
        DBService.createUser(manoUser: manoUser, completion: { (error) in
            if let error = error {
                self.authserviceCreateNewAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
            }
            self.authserviceCreateNewAccountDelegate?.didCreateNewAccount(self, user: manoUser)
        })
    }
    
    
    public func signInExistingAccount(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                self.authserviceExistingAccountDelegate?.didRecieveErrorSigningToExistingAccount(self, error: error)
            } else if let authDataResult = authDataResult {
                self.authserviceExistingAccountDelegate?.didSignInToExistingAccount(self, user: authDataResult.user)
            }
        }
    }
    
    
    public func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    public func signOutAccount() {
        do {
            try Auth.auth().signOut()
            authserviceSignOutDelegate?.didSignOut(self)
        } catch {
            authserviceSignOutDelegate?.didSignOutWithError(self, error: error)
        }
    }
    
    public func deleteAccount(completion: @escaping(Error?) -> Void) {
        Auth.auth().currentUser?.delete(completion: { (error) in
            if let error = error {
                completion(error)
            }
            DBService.deleteAccount(user: AuthService.currentManoUser, completion: { (error) in
                if let error = error {
                    completion(error)
                }
                completion(nil)
            })
        })
    }
}
