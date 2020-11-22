//
//  UIViewController+Notifications.swift
//  ozweather
//
//  Created by Xuwei Liang on 22/11/20.
//

import UIKit
import NotificationCenter

extension UIViewController {
    
    func removeNotificationEventObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}
