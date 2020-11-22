//
//  UIViewController+PushToViewController.swift
//  ozweather
//
//  Created by Xuwei Liang on 22/11/20.
//

import UIKit

extension UIViewController {
    
    func pushToWeatherDetailsWith(vm: WeatherDetailsVM) {
        pushToViewController(storyboardName: .main, storyboardId: .weatherDetails)
    }
    
    private func pushToViewController(storyboardName: StoryboardName, storyboardId: StoryboardId) {
        guard let nav =  self.navigationController else { return }
        guard let vc = self.viewControllerBy(storyboardName: storyboardName, storyboardId: storyboardId) else { return }
        nav.pushViewController(vc, animated: true)
    }
    
    private func viewControllerBy(storyboardName: StoryboardName, storyboardId: StoryboardId)->UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId.rawValue)
        return vc
    }
}
