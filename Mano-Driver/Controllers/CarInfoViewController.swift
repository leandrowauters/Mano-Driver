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

    @IBOutlet weak var carButton: Rounder10Button!
    @IBOutlet weak var userButton: Rounder10Button!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var plateTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    var selectedCarImage: UIImage?
    var selectedUserImage: UIImage?
    var selectedImage: SelectedImage?
    var selectedState: String?
    
    var userId = String()
    var auth = AuthService()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTap()
        auth.authserviceUpdateAccountDelegate = self
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        activityIndicator.startAnimating()
        updateUserInfo()
        
    }
    
    @IBAction func carButtonPressed(_ sender: Any) {
        showImagesSourceOptions(imagePickerController: imagePickerController)
        selectedImage = .car
    }
    
    @IBAction func userButtonPressed(_ sender: Any) {
        showImagesSourceOptions(imagePickerController: imagePickerController)
        selectedImage = .user
    }
    @IBAction func stateButtonPressed(_ sender: Any) {
        let pickerViewVC = PickerView_ViewController.init(nibName: "PickerView+ViewController", bundle: nil)
        pickerViewVC.delegate = self
        pickerViewVC.modalPresentationStyle = .overCurrentContext
        present(pickerViewVC, animated: true)
    }
    
    
    enum SelectedImage {
        case car
        case user
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
        let resizedImage = Toucan.init(image: originalImage).resize(CGSize(width: 414  , height: 250))
    switch selectedImage {

        case .car:
            selectedCarImage = resizedImage.image
            carButton.imageView?.contentMode = .scaleAspectFit
            carButton.setImage(selectedCarImage, for: .normal)
            dismiss(animated: true)
        case .user:
            selectedUserImage = resizedImage.image
            userButton.imageView?.contentMode = .scaleAspectFit
            userButton.setImage(selectedUserImage, for: .normal)
            dismiss(animated: true)
        default:
            dismiss(animated: true)
            
        }
    }
}

extension CarInfoViewController: PickerViewControllerDelegate {
    func accepted(usState: String) {
        self.selectedState = usState
        stateButton.setTitle(selectedState, for: .normal)
        dismiss(animated: true)
    }
    
    func cancel() {
        dismiss(animated: true)
    }
    
    
}
