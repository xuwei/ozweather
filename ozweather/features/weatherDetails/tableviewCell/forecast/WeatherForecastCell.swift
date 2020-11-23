//
//  WeatherForecastCell.swift
//  ozweather
//
//  Created by Xuwei Liang on 23/11/20.
//

import UIKit

class WeatherForecastCell: UITableViewCell {
    
    static let identifier: String = "WeatherForecastCell"
   
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var weatherLocationLabel: UILabel!
    @IBOutlet weak var weatherLocationCoord: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherImageIcon: UIImageView!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    var viewModel: WeatherForecastCellVM?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        let theme: ThemeProtocol = AppData.shared.theme
        containerView.backgroundColor = theme.primaryColor
    }
    
    // we always clear the content on cell before re-use
    override func prepareForReuse() {
        // reset content
        weatherLocationLabel.text = ""
        weatherLocationCoord.text = ""
        weatherDescriptionLabel.text = ""
        feelsLikeTemperatureLabel.text = ""
        countryLabel.text = ""
        weatherImageIcon.image = nil
    }
}

extension WeatherForecastCell: TableViewCellProtocol {
    func setupWith(_ vm: TableViewCellVMProtocol) {
        guard let viewModel = vm as? WeatherForecastCellVM else { return }
        self.weatherLocationLabel.text = viewModel.location
        self.weatherLocationCoord.text = viewModel.coordString
        self.weatherDescriptionLabel.text = viewModel.description
        self.feelsLikeTemperatureLabel.text = String("Feels like \(viewModel.temperature)")
        self.countryLabel.text = viewModel.country
    }
}