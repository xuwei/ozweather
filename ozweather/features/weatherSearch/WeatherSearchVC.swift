//
//  ViewController.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import UIKit

class WeatherSearchVC: UIViewController, WeatherSearchVMDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noResultLabel: UILabel!
    
    var viewModel = WeatherSearchVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupTableview()
        registerCells()
        enableTapToKeyboardDismiss()
    }
    
    private func setupTableview() {
        guard let tableView = self.tableView else { return }
        
        /// default is 0, setting to more than 0 enables automatic cell height, will calculate by intrinsic value
        tableView.estimatedRowHeight = 1
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
    }
    
    private func registerCells() {
        guard self.tableView != nil else { return }
        let cellIdentifier = WeatherLocationCell.identifier
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func enableTapToKeyboardDismiss() {
        
    }
    
    func updateTable() {
        self.tableView.reloadData()
    }
}

extension WeatherSearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension WeatherSearchVC: UISearchBarDelegate {
    
}
