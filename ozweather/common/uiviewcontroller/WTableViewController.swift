//
//  WTableViewController.swift
//  ozweather
//
//  Created by Xuwei Liang on 23/11/20.
//

import UIKit

class WTableVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    let refreshControl = UIRefreshControl()
    
    func addRefreshControl() {
        guard let tableView = self.tableView else { return }
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func showLoading() {
        guard let loadingIndicator = self.loadingIndicator else { return }
        loadingIndicator.startAnimating()
    }
    
    func endLoading() {
        guard let loadingIndicator = self.loadingIndicator else { return }
        loadingIndicator.stopAnimating()
    }
    
    // to be overriden
    @objc func refresh() { }
    
}
