//
//  CarInfo+UpdateInfo+Extension.swift
//  Mano-Driver
//
//  Created by Leandro Wauters on 10/15/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation
import UIKit

extension CarInfoViewController: AuthServiceUpdateAccountDelegate {

    
    
    
    func updateUserInfo() {
        guard let make = makeTextField.text,
            let model = modelTextField.text,
            let state = selectedState,
            let plate = plateTextField.text,
            !make.isEmpty, !model.isEmpty, !plate.isEmpty,
            let selectedFrontImage = selectedCarImage,
            let selectedBackImage = selectedUserImage,
        let frontImage = selectedFrontImage.jpegData(compressionQuality: 0.5),
            let backImage = selectedBackImage.jpegData(compressionQuality: 0.5) else {
                activityIndicator.stopAnimating()
                showAlert(title: "Please complete missing fields", message: nil)
                return
        }
        StorageService.postImages(imagesData: [frontImage, backImage], imageNames: ["\(userId)_Front+Image", "\(userId)_Back+Image"]) { [weak self] error, urls in
            
            if let error = error {
                self?.activityIndicator.stopAnimating()
                self?.showAlert(title: "Error posting image", message: error.localizedDescription)
            }
            if let urls = urls {
                self?.auth.updateCarInfo(userId: self!.userId, make: make, model: model, state: state, plate: plate, frontImage: urls[0].absoluteString, backImage: urls[1].absoluteString)
            }
        }
        
    }
    
    func didUpdateAccount() {
        activityIndicator.stopAnimating()
        segueToAvailableRides(userId: userId)
    }
    
    func didRecieveErrorUpdatingAccount(error: Error) {
        showAlert(title: "Error Updating account", message: error.localizedDescription)
    }
}


