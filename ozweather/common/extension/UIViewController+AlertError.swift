//
//  UIViewController+AlertError.swift
//  ozweather
//
//  Created by Xuwei Liang on 22/11/20.
//

import UIKit

extension UIViewController {
    
    func alert(error: Error, completionHandler: ((UIAlertAction)->Void)?) {
        BasicLogger.shared.logError(error)
        let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: completionHandler)
        alertVC.addAction(action)
        var top: UIViewController = self
        if let topMost = self.topMostViewController() { top = topMost }
        top.present(alertVC, animated: true, completion: nil)
    }
}
