//
//  ViewController.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import UIKit
import CoreLocation
import NotificationCenter

class WeatherSearchVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    let refreshControl = UIRefreshControl()
    
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
        viewModel.loadRecent() { _ in
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
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
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
    
    private func showLoading() {
        self.loadingIndicator.startAnimating()
    }
    
    private func endLoading() {
        self.loadingIndicator.stopAnimating()
    }
    
    @objc private func refresh() {
        self.viewModel.loadRecent { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
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
        print("delete")
        self.viewModel.removeRecent(vm) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        }
    }
    
    func weatherForecast(vm: WeatherLocationCellVM) {
        print("weather location selected")
        let weatherDetailsVM = WeatherDetailsVM(weatheService: OpenWeatherAPIMock.shared, request: WeatherSearchRequest(city: vm.text, type: vm.type))
        pushToWeatherDetailsWith(vm: weatherDetailsVM)
    }
}

// MARK: UseGPSLocationCellDelegate
extension WeatherSearchVC: UseGPSLocationCellDelegate {
    func useCurrentLocation(vm: UseGPSLocationCellVM) {
        print("use current location")
        self.viewModel.startLocationService()
    }
}

// MARK: UISearchBarDelegate
extension WeatherSearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text else { return }
        var req: WeatherSearchRequest?
        // validate text input and transform to request object
        let searchReqUtil = WeatherSearchRequestUtil()
        let reqType = searchReqUtil.typeOfRequest(text)
        switch reqType {
        case .city:
            req = WeatherSearchRequest(city: text, type: .city)
            break
        case .zipCode:
            req = WeatherSearchRequest(zip: text, type: .zipCode)
            break
        default:
            alert(error: WeatherServiceError.invalidParamFormat, completionHandler: nil)
            return
        }
        guard let request = req else { alert(error: WeatherServiceError.invalidParamFormat, completionHandler: nil); return }
        self.showLoading()
        self.viewModel.queueSearch(request) { result in
            DispatchQueue.main.async { [weak self]  in
                guard let self = self else { return }
                self.endLoading()
                
                switch result {
                case .success(let forecast):
                    // save recent
                    self.viewModel.saveRecent(request)
                    // navigate to weather details
                    let weatherDetailsVM = WeatherDetailsVM(weatheService: OpenWeatherAPI.shared, request: request, forecast: forecast)
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
