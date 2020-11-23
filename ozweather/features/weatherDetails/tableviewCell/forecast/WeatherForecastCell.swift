//
//  WeatherForecastCell.swift
//  ozweather
//
//  Created by Xuwei Liang on 23/11/20.
//

import UIKit

class WeatherForecastCell: UITableViewCell {
    
    static let identifier: String = "WeatherForecastCell"
    private let placeholderImage = "weatherIconPlaceholder"
   
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
        containerView.backgroundColor = theme.backgroundColor
        weatherLocationLabel.textColor = theme.primaryTextColor
    }
    
    // we always clear the content on cell before re-use
    override func prepareForReuse() {
        // reset content
        weatherLocationLabel.text = ""
        weatherLocationCoord.text = ""
        weatherDescriptionLabel.text = ""
        feelsLikeTemperatureLabel.text = ""
        countryLabel.text = ""
        weatherImageIcon.image = UIImage.init(named: placeholderImage)
    }
}

extension WeatherForecastCell: TableViewCellProtocol {
    func setupWith(_ vm: TableViewCellVMProtocol) {
        guard let viewModel = vm as? WeatherForecastCellVM else { return }
        weatherLocationLabel.text = viewModel.location
        weatherLocationCoord.text = viewModel.coordString
        weatherDescriptionLabel.text = viewModel.weatherDescription
        feelsLikeTemperatureLabel.text = String("Feels like \(viewModel.temperature) °C")
        countryLabel.text = viewModel.country
    }
}
