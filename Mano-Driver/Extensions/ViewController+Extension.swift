//
//  ViewController+Tap.swift
//  Mano-Driver
//
//  Created by Leandro Wauters on 10/15/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setupTap() {
        
        let screenTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
    }
    
    func segueToAvailableRides() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let availableRides = storyboard.instantiateViewController(withIdentifier: "AvailableRides") as! AvailableRides
        self.navigationController?.pushViewController(availableRides, animated: true)
    }
}