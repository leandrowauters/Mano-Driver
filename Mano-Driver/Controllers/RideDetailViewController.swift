//
//  RideDetailViewController.swift
//  Mano-Driver
//
//  Created by Leandro Wauters on 10/17/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class RideDetailViewController: UIViewController {

    weak var ride: Ride!
    let dbService = DBService()
    let calendarHelper = CalendarHelper()
    @IBOutlet weak var pickupDropoffAddressLabel: UILabel!
    @IBOutlet weak var appointmentAddressLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbService.rideStatusChangeDelegate = self
        calendarHelper.calendarDelegate = self
        setupUI()
    }
    
    func setupUI() {
        pickupDropoffAddressLabel.text = ride.pickupAddress
        appointmentAddressLabel.text = ride.dropoffAddress
        dateLabel.text = ride.appointmentDate
    }
    
    @IBAction func saveForLaterPressed(_ sender: Any) {
    }
    
    @IBAction func acceptRequestPressed(_ sender: Any) {
        showTwoButtonAlert(title: "Accept Ride?", firstButtonTitle: "No", secondButtonTitle: "Yes", message: "\(ride.passanger) will be notified") { [weak self] alertAction in
            if alertAction.title == "No" {
                
            } else {
                self?.dbService.changeRideStatus(ride: self!.ride, rideStatus: RideStatus.pickupAccepted)
            }

        }

//        DBService.updateRideToAccepted(ride: selectedRide) { (error) in
//            if let error = error {
//                self.showAlert(title: "Error updating ride", message: error.localizedDescription)
//            }
//        }
//        mapDetailView.isHidden = true
//        let rideAcceptedAlert = RideAcceptedAlertViewController(nibName: nil, bundle: nil, ride: selectedRide)
//        rideAcceptedAlert.modalPresentationStyle = .overCurrentContext
//        present(rideAcceptedAlert, animated: true)
    }
    

}

extension RideDetailViewController: RideStatusChangeDelegate {
    func didChangeStatus() {
        showTwoButtonAlert(title: "Ride accepted", firstButtonTitle: "Add to calendar", secondButtonTitle: "Continue", message: "\(ride.appointmentDate)\n \(ride.pickupAddress)") { (alertAction) in
            if alertAction.title == "Add to calendar" {
                self.calendarHelper.addToCalendar(ride: self.ride)
            } else {
                self.dismiss(animated: true)
            }
        }
    }
    
    func errorChangingStatus(error: Error) {
        showAlert(title: "Error changing status", message: error.localizedDescription)
    }
    
    
}

extension RideDetailViewController: CalendarDelegate {
    func didAddToCalendar(calendar: String) {
        showAlert(title: "Added to calendar", message: nil) { (action) in
            self.dismiss(animated: true)
        }
        
        
        
    }
    
    func errorAddingToCalendar(error: AppError) {
        showAlert(title: error.errorMessage(), message: nil) { (action) in
            self.dismiss(animated: true)
        }
    }
}
