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
    
    var viewModel = WeatherSearchVM(searchCache: WeatherSearchCacheMock.shared, weatheService: OpenWeatherAPIMock.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        setupTableview()
        registerCells()
        enableTapToDismissKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadRecent() { _ in
            tableView.reloadData()
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
        tableView.backgroundColor = AppData.shared.theme.backgroundColor
        
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
        BasicLogger.shared.log(self.viewModel.sections[section].title)
        return self.viewModel.sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel.sections[indexPath.section].cellVMList[indexPath.row]
        guard let cell: TableViewCellProtocol = tableView.dequeueReusableCell(withIdentifier: cellModel.identifier, for: indexPath) as? TableViewCellProtocol else {
            return UITableViewCell()
        }
        cell.setupWith(cellModel)
        guard let tableViewCell = cell as? UITableViewCell else {
            return UITableViewCell()
        }
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = viewModel.sections[indexPath.section].cellVMList[indexPath.row]
        let cellModelType = type(of: cellModel)
        if cellModelType == UseGPSLocationCellVM.self {
            print("gps location selected")
        } else if cellModelType == WeatherLocationCellVM.self {
            guard let cellVM = cellModel as? WeatherLocationCellVM else { return }
            print("weather location selected")
            let weatherDetailsVM = WeatherDetailsVM(weatheService: OpenWeatherAPIMock.shared, request: WeatherSearchRequest(city: cellVM.text, type: cellVM.type))
            pushToWeatherDetailsWith(vm: weatherDetailsVM)
        }
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
        self.viewModel.queueSearch(request) { [weak self] result in
            guard let self = self else { return }
            self.endLoading()
            
            switch result {
            case .success(let forecast):
                // cache search result
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
