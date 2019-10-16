//
//  LoginViewController.swift
//  Mano
//
//  Created by Leandro Wauters on 9/1/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var LoginButton: RoundedButton!
    @IBOutlet weak var signUpButton: RoundedButton!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    private var authservice = AppDelegate.authservice
    private var keyboardNotification = KeyboardNotification()
    
    private var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        authservice.authserviceExistingAccountDelegate = self
        setupTap()
        keyboardNotification.delegate = self
        GIDSignIn.sharedInstance().delegate = self
        setupTextFieldsDelegates()
        googleSignInSetup()
        keyboardNotification.registerKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        keyboardNotification.unregisterKeyboardNotifications()
    }
    
    
    private func googleSignInSetup() {
        signInButton.layer.cornerRadius = 10
        signInButton.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(signinWithGoogle))
        signInButton.addGestureRecognizer(tap)
        signInButton.style = .wide
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    @objc func signinWithGoogle() {
        GIDSignIn.sharedInstance().signIn()
        
    }
    

    
    private func setupTextFieldsDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    

    
    private func signInCurrentUser(){
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
            else {
                showAlert(title: "Please enter information", message: "ex: yourmail@email.com")
                return
        }
        authservice.signInExistingAccount(email: email, password: password)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterKeyboardNotifications()
    }
    
    
    private func unregisterKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Google sign in" {
            guard let createAccVC = segue.destination as? CreateAccountViewController else {return}
            createAccVC.user = self.user
            createAccVC.googleUser = true
        }
    }

    @IBAction func signupPressed(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Login+Create+Storyboard", bundle: nil).instantiateViewController(identifier: "CreateAccountViewController") as CreateAccountViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginViewController : AuthServiceExistingAccountDelegate {
    func didSignInToExistingAccount(_ authservice: AuthService, user: User) {
        segueToAvailableRides()
        
    }
    
    func didRecieveErrorSigningToExistingAccount(_ authservice: AuthService, error: Error) {
        showAlert(title: "Signin Error", message: error.localizedDescription)
    }
    
}

extension LoginViewController: GIDSignInDelegate {
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            self.showAlert(title: "Error signing in with google", message: error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                self.showAlert(title: "Error setting credantials", message: error.localizedDescription)
                return
            }
            if let user = Auth.auth().currentUser {
                DBService.fetchManoUser(userId: user.uid, completion: { (error, manoUser) in
                    if let error = error {
                        self.showAlert(title: "Error fetching user", message: error.localizedDescription)
                    }
                    if let manoUser = manoUser {
                        AuthService.currentManoUser = manoUser
                    } else {
                        self.user = user
                        self.performSegue(withIdentifier: "Google sign in", sender: self)
                        
                    }
                })
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    
}

extension LoginViewController: KeyboardNotificationDelegate {
    func transformView(keyboardFrame: CGRect) {
        view.transform = CGAffineTransform.init(translationX: 0, y: -keyboardFrame.height + 200)
    }
    
    func hideView() {
        view.transform = CGAffineTransform.identity
    }
    
    
}
