//
//  CreateAccountViewController.swift
//  Mano
//
//  Created by Leandro Wauters on 9/1/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces

enum TypeOfUser: String {
    case driver,passenger
}
class CreateAccountViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    @IBOutlet weak var homeAddressButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var user: User?
    var googleUser = false
    var homeLat: Double?
    var homeLon: Double?
    private var scrollUp = Bool()
    private var authservice = AppDelegate.authservice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldDelegatesAndType()
        setupTap()
        setup()
        authservice.authserviceCreateNewAccountDelegate = self
    }
    

    

    

    private func setup() {
        if let user = user {
            emailTextField.text = user.email
            let names = user.displayName?.components(separatedBy: " ")
            firstNameTextField.text = names?.first
            lastNameTextField.text = names?.last
            passwordTextField.text = "1234567"
            confirmPasswordTextField.text = "1234567"
            let texfFields = [firstNameTextField, lastNameTextField, emailTextField, passwordTextField, confirmPasswordTextField]
            texfFields.forEach { (textfield) in
                textfield?.isEnabled = false
                textfield?.alpha = 0.7
            }
        }
    }
    


    func setupTextFieldDelegatesAndType() {
        emailTextField.textContentType = .oneTimeCode
        passwordTextField.textContentType = .oneTimeCode
        confirmPasswordTextField.textContentType = .oneTimeCode
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    

    


    private func createNewUser(){
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let homeAddress = homeAddressButton.titleLabel?.text,
            let phoneNumber = phoneNumberTextField.text,
            !email.isEmpty,
            !confirmPassword.isEmpty,
            !password.isEmpty,
            !firstName.isEmpty,
            !lastName.isEmpty,
            !homeAddress.isEmpty,
            !phoneNumber.isEmpty
            else {
                showAlert(title: "Missing Required Fields", message: nil)
                return
        }
        if password != confirmPassword {
            showAlert(title: "Passwords do not match", message: "Try again")
        } else {
            if googleUser {
                authservice.createGoogleAccountUser(firstName: firstName, lastName: lastName, email: user?.email ?? "N/A", typeOfUser: TypeOfUser.driver.rawValue, phone: phoneNumber, homeAddress: homeAddress, userId: user?.uid ?? "N/A", homeLat: homeLat!, homeLon: homeLon!)
            } else {
                authservice.createAccount(firstName: firstName, lastName: lastName, password: password, email: email, typeOfUser: TypeOfUser.driver.rawValue, phone: phoneNumber, homeAddress: homeAddress, homeLat: self.homeLat!, homeLon: self.homeLon!)
            }

        }
        
    }
    @IBAction func homeAddressPressed(_ sender: UIButton) {
        MapsHelper.shared.setupAutoCompeteVC(Vc: self)
    }
    @IBAction func backPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func createAccount(_ sender: Any) {
        createNewUser()
        activityIndicator.startAnimating()
    }
    
}

extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateAccountViewController : AuthServiceCreateNewAccountDelegate {
    func didRecieveErrorCreatingAccount(_ authservice: AuthService, error: Error) {
        showAlert(title: "Account Creation Error", message: error.localizedDescription)
    }
    
    func didCreateNewAccount(_ authservice: AuthService, user: ManoUser) {
        let vc = UIStoryboard(name: "Login+Create+Storyboard", bundle: nil).instantiateViewController(identifier: "CarInfoViewController") as CarInfoViewController
        vc.userId = user.userId
        self.navigationController?.pushViewController(vc, animated: true)
        activityIndicator.stopAnimating()
        
    }
    
}

extension CreateAccountViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        guard let dropoffAddress = place.formattedAddress else {
            showAlert(title: "Error finding address", message: nil)
            return}
        homeAddressButton.setTitle(dropoffAddress, for: .normal)
        self.homeLon = place.coordinate.longitude
        self.homeLat = place.coordinate.latitude
        dismiss(animated: true)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}


