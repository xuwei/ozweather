//
//  BasicAppNav.swift
//  ozweather
//
//  Created by Xuwei Liang on 22/11/20.
//

import UIKit

class AppNav: AppNavProtocol {
    
    func pushToViewController(_ storyboardName: String, storyboardId: String, sourceVC: UIViewController) {
        guard let nav =  sourceVC.navigationController else { return }
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId)
        nav.pushViewController(vc, animated: true)
    }
}
