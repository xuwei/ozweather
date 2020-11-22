//
//  NotificationConstants.swift
//  ozweather
//
//  Created by Xuwei Liang on 22/11/20.
//
import Foundation

// NotificationEvent for events across the app, don't hardcode event names, update enum for lookup instead
public enum NotificationEvent: String {
    case locationUpdate = "locationUpdate"
}

// NotificationEvent UserInfoKey
public enum NotificationUserInfoKey: String {
    case currentLocation = "currentLocation"
}
