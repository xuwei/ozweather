//
//  ViewController.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import UIKit

class WeatherSearchVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var viewModel = WeatherSearchVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupTableview()
        registerCells()
        enableTapToDismissKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadRecent()
    }
    
    private func setupTableview() {
        guard let tableView = self.tableView else { return }
        
        /// default is 0, setting to more than 0 enables automatic cell height, will calculate by intrinsic value
        tableView.estimatedRowHeight = 1
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self 
    }
    
    private func registerCells() {
        guard self.tableView != nil else { return }
        
        // cell for recent searched weather location
        let nib = UINib(nibName: WeatherLocationCell.identifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: WeatherLocationCell.identifier)
        
        // cell for current location with gps
        let nib2 = UINib(nibName: UseGPSLocationCell.identifier, bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: UseGPSLocationCell.identifier)
    }
}

extension WeatherSearchVC: WeatherSearchVMDelegate {
    func updateTable() {
        tableView.reloadData()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension WeatherSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section: WeatherSearchSection = self.viewModel.sections[section]
        return section.cellVMList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel.sections[indexPath.section].cellVMList[indexPath.row]
        guard let cell: TableViewCellProtocol = tableView.dequeueReusableCell(withIdentifier: cellModel.identifier, for: indexPath) as? TableViewCellProtocol else { return UITableViewCell() }
        cell.setupWith(cellModel)
        guard let tableViewCell = cell as? UITableViewCell else { return UITableViewCell() }
        return tableViewCell
    }
}

// MARK: UISearchBarDelegate
extension WeatherSearchVC: UISearchBarDelegate {
    
}
