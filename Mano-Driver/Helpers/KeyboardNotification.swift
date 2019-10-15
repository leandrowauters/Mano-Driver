//
//  KeyboardNotification.swift
//  Mano-Driver
//
//  Created by Leandro Wauters on 10/14/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardNotificationDelegate: AnyObject {
    func transformView(keyboardFrame: CGRect)
    func hideView()
}
class KeyboardNotification {
    
    weak var delegate: KeyboardNotificationDelegate?
    
    func registerKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unregisterKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func willShowKeyboard(notification: Notification){
        guard let info = notification.userInfo,
            let keyboardFrame = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
                print("UserInfo is nil")
                return
        }
            delegate?.transformView(keyboardFrame: keyboardFrame)
    }
    
    @objc private func willHideKeyboard(){
        delegate?.hideView()
    }
}
