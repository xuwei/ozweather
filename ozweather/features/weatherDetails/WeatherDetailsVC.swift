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
        let nib = UINib(nibName: WeatherLocationCell.identifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: WeatherLocationCell.identifier)
        
        // cell for current location with gps
        let nib2 = UINib(nibName: UseGPSLocationCell.identifier, bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: UseGPSLocationCell.identifier)
    }
}

extension WeatherDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return  UITableViewCell()
    }
}
