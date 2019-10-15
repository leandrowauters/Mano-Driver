//
//  CarInfo+UpdateInfo+Extension.swift
//  Mano-Driver
//
//  Created by Leandro Wauters on 10/15/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation
import UIKit

extension CarInfoViewController {
    func updateUserInfo() {
        guard let make = makeTextField.text,
            let model = modelTextField.text,
            let state = selectedState,
            let plate = plateTextField.text,
            !make.isEmpty, !model.isEmpty, !plate.isEmpty,
            let selectedFrontImage = selectedFrontImage,
            let selectedBackImage = selectedBackImage,
        let frontImage = selectedFrontImage.jpegData(compressionQuality: 0.5),
            let backImage = selectedBackImage.jpegData(compressionQuality: 0.5) else {
                showAlert(title: "Place complete missing fields", message: nil)
                return
        }
        StorageService.postImages(imagesData: [frontImage, backImage], imageNames: ["Front+Image", "Back+Image"]) { [weak self] error, urls in
            
            if let error = error {
                self?.showAlert(title: "Error posting image", message: error.localizedDescription)
            }
            if let urls = urls {
                DBService.updateCarInfo(userId: self!.userId, make: make, model: model, state: state, plate: plate, frontImage: urls[0].absoluteString , backImage: urls[1].absoluteString) { (error) in
                    if let error = error {
                        self?.showAlert(title: "Error updating", message: error.localizedDescription)
                    }
                }
            }
        }
    }
}
