//
//  CarInfoViewController.swift
//  Mano-Driver
//
//  Created by Leandro Wauters on 10/14/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit
import Toucan
import Kingfisher
class CarInfoViewController: UIViewController {

    @IBOutlet weak var frontButton: Rounder10Button!
    @IBOutlet weak var backButton: Rounder10Button!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var plateTextField: UITextField!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    var selectedFrontImage: UIImage?
    var selectedBackImage: UIImage?
    var selectedImage: SelectedImage?
    var selectedState: String?
    
    var userId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTap()
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        updateUserInfo()
    }
    
    @IBAction func frontButtonPressed(_ sender: Any) {
        showImagesSourceOptions(imagePickerController: imagePickerController)
        selectedImage = .front
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        showImagesSourceOptions(imagePickerController: imagePickerController)
        selectedImage = .back
    }
    
    enum SelectedImage {
        case front
        case back
    }

}

extension CarInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                print("original image is nil")
                return
            }
    switch selectedImage {
        case .front:
            selectedFrontImage = originalImage
            frontButton.imageView?.contentMode = .scaleAspectFit
            frontButton.setImage(selectedFrontImage, for: .normal)
            dismiss(animated: true)
        case .back:
            selectedBackImage = originalImage
            frontButton.imageView?.contentMode = .scaleAspectFit
            backButton.setImage(selectedBackImage, for: .normal)
            dismiss(animated: true)
        default:
            dismiss(animated: true)
            
        }
    }
}
