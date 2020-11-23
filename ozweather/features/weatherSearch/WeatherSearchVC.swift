//
//  ViewController.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import UIKit
import CoreLocation
import NotificationCenter

class WeatherSearchVC: WTableVC {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel = WeatherSearchVM()
    
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
        addEventObservers()
        viewModel.loadRecent() {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        }
    }
    
    // important to de-register events when viewcontroller disappears
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.stopLocationService()
        removeNotificationEventObservers()
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
        tableView.backgroundColor = AppData.shared.theme.backgroundColor
        tableView.allowsSelection = false
        
        // add refresh controller
        addRefreshControl()
        addLoadingIndicator()
    }
    
    private func addEventObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(locationUpdate(notification:)), name: NSNotification.Name(NotificationEvent.locationUpdate.rawValue), object: nil)
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
    
    // handling location update events
    @objc private func locationUpdate(notification: NSNotification) {
        BasicLogger.shared.log("weather search vc - location update")
        guard let location = notification.userInfo?[NotificationUserInfoKey.currentLocation.rawValue] as? CLLocation else { return }
        self.viewModel.updateLocation(location) { _ in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        }
    }
    
    // overriding parent method
    @objc override func refresh() {
        refreshControl.beginRefreshing()
        self.viewModel.loadRecent {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
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
        guard let cell: TableViewCellProtocol = tableView.dequeueReusableCell(withIdentifier: cellModel.identifier, for: indexPath) as? TableViewCellProtocol else {
            return UITableViewCell()
        }
        cell.setupWith(cellModel)
        if let locationCell = cell as? WeatherLocationCell {
            locationCell.delegate = self
        } else if let gpsLocationCell = cell as? UseGPSLocationCell {
            gpsLocationCell.delegate = self
        }
    
        return cell as? UITableViewCell ?? UITableViewCell()
    }
}

// MARK: WeatherLocationCellDelegate
extension WeatherSearchVC: WeatherLocationCellDelegate {
    
    func delete(vm: WeatherLocationCellVM) {
        BasicLogger.shared.log("delete recent")
        self.viewModel.removeRecent(vm)
        self.viewModel.loadRecent {
            DispatchQueue.main.async { [weak self] in
               guard let self = self else { return }
               self.tableView.reloadData()
           }
        }
    }
    
    func weatherForecast(vm: WeatherLocationCellVM) {
        BasicLogger.shared.log("weather location selected")
        guard let req = self.viewModel.toSearchRequest(vm.text) else { alert(error: WeatherServiceError.invalidParamFormat, completionHandler: nil); return }
        let weatherDetailsVM = WeatherDetailsVM(title: vm.text,weatheService: OpenWeatherAPI.shared, request: req)
        pushToWeatherDetailsWith(vm: weatherDetailsVM)
    }
}

// MARK: UseGPSLocationCellDelegate
extension WeatherSearchVC: UseGPSLocationCellDelegate {
    
    func useCurrentLocation(vm: UseGPSLocationCellVM) {
        BasicLogger.shared.log("use current location")
        if self.viewModel.isLocationServiceActive(),
           let location = self.viewModel.location {
            let request = WeatherSearchRequest(coord: location, type: .gpsCoord)
            self.viewModel.search(request) { result in
                DispatchQueue.main.async { [weak self]  in
                    guard let self = self else { return }
                    switch result {
                    case .success(let forecast):
                        let weatherDetailsVM = WeatherDetailsVM(title: "GPS Location", weatheService: OpenWeatherAPI.shared, request: request, forecast: forecast)
                        self.pushToWeatherDetailsWith(vm: weatherDetailsVM)
                        break
                    case .failure(let error):
                        self.alert(error: error, completionHandler: nil)
                        break
                    }
                }
            }
        } else {
            self.viewModel.startLocationService()
        }
    }
}

// MARK: UISearchBarDelegate
extension WeatherSearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text else { return }
        
        // validate
        guard let searchReq = self.viewModel.toSearchRequest(text) else { alert(error: WeatherServiceError.invalidParamFormat, completionHandler: nil); return }
        
        self.showLoading()
        self.viewModel.search(searchReq) { result in
            DispatchQueue.main.async { [weak self]  in
                guard let self = self else { return }
                self.endLoading()
                
                switch result {
                case .success(let forecast):
                    // save recent
                    self.viewModel.saveRecent(searchReq)
                    // navigate to weather details
                    let weatherDetailsVM = WeatherDetailsVM(title: text,weatheService: OpenWeatherAPI.shared, request: searchReq, forecast: forecast)
                    self.pushToWeatherDetailsWith(vm: weatherDetailsVM)
                    break
                case .failure(let err):
                    self.alert(error: err, completionHandler: nil)
                    break
                }
            }
        }
    }
}
