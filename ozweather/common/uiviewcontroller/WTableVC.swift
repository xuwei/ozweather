//
//  WTableViewController.swift
//  ozweather
//
//  Created by Xuwei Liang on 23/11/20.
//

import UIKit

class WTableVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let loadingIndicatorSize: CGFloat = 50.0
    let refreshControl = UIRefreshControl()
    
    func addRefreshControl() {
        guard let tableView = self.tableView else { return }
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func addLoadingIndicator() {
        // avoiding adding again
        guard !self.loadingIndicator.isDescendant(of: self.view)  else { return }
        self.loadingIndicator = UIActivityIndicatorView()
        self.loadingIndicator.style = .whiteLarge
        let theme = AppData.shared.theme
        self.loadingIndicator.color = theme.primaryColor
        self.view.addSubview(self.loadingIndicator)
        AutoLayoutUtil.shared.pinToSuperviewCenter(self.loadingIndicator, width: loadingIndicatorSize, height: loadingIndicatorSize)
    }
    
    func showLoading() {
        guard self.loadingIndicator.isDescendant(of: self.view) else { return }
        self.loadingIndicator.startAnimating()
    }
    
    func endLoading() {
        guard self.loadingIndicator.isDescendant(of: self.view) else { return }
        self.loadingIndicator.stopAnimating()
    }
    
    // to be overriden
    @objc func refresh() {
        BasicLogger.shared.log("WTableVC refresh method is not overriden")
    }
    
}