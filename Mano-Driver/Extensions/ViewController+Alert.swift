//
//  ViewController+Alert.swift
//  Mano
//
//  Created by Leandro Wauters on 8/31/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    public func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    public func showAlert(title: String?, message: String?, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    public func showSheetAlert(title: String, message: String?, handler: @escaping (UIAlertController) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        handler(alertController)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true)
        }
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    public func showTwoButtonAlert(title: String?, firstButtonTitle: String, secondButtonTitle: String, message: String?, handler: ((UIAlertAction) -> Void)?)  {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: firstButtonTitle, style: .default, handler: handler)
        let secondAction = UIAlertAction(title: secondButtonTitle, style: .default, handler: handler)
        alertController.addAction(okAction)
        alertController.addAction(secondAction)
        present(alertController, animated: true, completion: nil)
    }
}
