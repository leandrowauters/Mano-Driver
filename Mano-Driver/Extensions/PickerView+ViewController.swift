//
//  PickerView+ViewController.swift
//  Mano-Driver
//
//  Created by Leandro Wauters on 10/15/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

protocol PickerViewControllerDelegate {
    func accepted(usState: String)
    func cancel()
}
class PickerView_ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var delegate: PickerViewControllerDelegate?
    var selectedState: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        // Do any additional setup after loading the view.
    }

    @IBAction func acceptPressed(_ sender: Any) {
        delegate?.accepted(usState: selectedState)
    }
    @IBAction func cancelPressed(_ sender: Any) {
        delegate?.cancel()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return USStates.usStates.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selectedState = USStates.usStates[row]
        return USStates.usStates[row]
    }

}
