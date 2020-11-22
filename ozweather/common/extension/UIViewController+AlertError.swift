//
//  UIViewController+AlertError.swift
//  ozweather
//
//  Created by Xuwei Liang on 22/11/20.
//

import UIKit

extension UIViewController {
    
    func alert(error: Error, completionHandler: (()->Void)?) {
        let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        self.present(alertVC, animated: true, completion: completionHandler)
    }
}
