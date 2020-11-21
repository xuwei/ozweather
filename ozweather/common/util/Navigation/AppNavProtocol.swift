//
//  AppNavProtocol.swift
//  ozweather
//
//  Created by Xuwei Liang on 22/11/20.
//

import UIKit

protocol AppNavProtocol {
    func pushToViewController(_ storyboardName: String, storyboardId: String, sourceVC: UIViewController)
}
