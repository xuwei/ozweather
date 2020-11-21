//
//  UIViewController_TapToDismissKeyboard.swift
//  ozweather
//
//  Created by Xuwei Liang on 21/11/20.
//

import UIKit

extension UIViewController {
    
    func enableTapToDismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
