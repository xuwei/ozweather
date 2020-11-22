//
//  NotificationUtil.swift
//  ozweather
//
//  Created by Xuwei Liang on 22/11/20.
//

import UIKit
import UserNotifications

class NotificationUtil {
    static let shared = NotificationUtil()
    private init() { }
    
    func notify(eventName: NotificationEvent, userInfokey: NotificationUserInfoKey, object: Any?) {
        var dataDict:[String: Any] = [:]
        if object != nil {
            dataDict = [userInfokey.rawValue: object ?? ""]
        }
        NotificationCenter.default.post(name: Notification.Name(eventName.rawValue), object: nil, userInfo: dataDict)
    }
}
