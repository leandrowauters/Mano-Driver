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
    private var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        GIDSignIn.sharedInstance().delegate = self
        registerKeyboardNotifications()
        setupTextFieldsDelegates()
        googleSignInSetup()
        // Do any additional setup after loading the view.
    }
    
    private func registerKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyBaord), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyBaord), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func willShowKeyBaord(notification: Notification){
        guard let info = notification.userInfo, let keyBoardFrame = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
            print("UserInfo is nil")
            return
        }
        //print(" UserInfo is:  \(info)")
        view.transform = CGAffineTransform.init(translationX: 0, y: -keyBoardFrame.height + 200)
    }
    
    @objc private func willHideKeyBaord(notification: Notification){
        view.transform = CGAffineTransform.identity
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
    
    private func setup() {
        
        let screenTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
        authservice.authserviceExistingAccountDelegate = self
    }
    
    private func setupTextFieldsDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
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


}
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginViewController : AuthServiceExistingAccountDelegate {
    func didSignInToExistingAccount(_ authservice: AuthService, user: User) {
        DBService.fetchManoUser(userId: user.uid) { (error, manoUser) in
            if let error = error {
                self.showAlert(title: "Error signign in", message: error.localizedDescription)
            }
            if let manoUser = manoUser {
                DBService.currentManoUser = manoUser
            }
        }
        
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
                        DBService.currentManoUser = manoUser
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
