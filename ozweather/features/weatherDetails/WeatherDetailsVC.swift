//
//  WeatherDetails.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import Foundation
import UIKit

class WeatherDetailsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
 
    var viewModel = WeatherDetailsVM(title: "", weatheService: OpenWeatherAPIMock.shared, request: WeatherSearchRequest(city: "", type: .city))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        setupTableview()
        registerCells()
        enableTapToDismissKeyboard()

    }
    
    // register for notification events when viewcontroller appears
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.refreshForecast { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        }
    }
        
    private func setupTableview() {
        guard let tableView = self.tableView else { return }
        
        /// default is 0, setting to more than 0 enables automatic cell height, will calculate by intrinsic value
        tableView.estimatedRowHeight = 1
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    private func registerCells() {
        guard self.tableView != nil else { return }
        
        // cell for recent searched weather location
        let nib = UINib(nibName: WeatherForecastCell.identifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: WeatherForecastCell.identifier)
    }
}

extension WeatherDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.viewModel.forecastLoaded() ? 1 : 0
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cellModel = self.viewModel.cellVM, let cell: TableViewCellProtocol = tableView.dequeueReusableCell(withIdentifier: cellModel.identifier, for: indexPath) as? TableViewCellProtocol else {
            return UITableViewCell()
        }
        
        cell.setupWith(cellModel)
        return cell as? UITableViewCell ?? UITableViewCell()
    }
}
