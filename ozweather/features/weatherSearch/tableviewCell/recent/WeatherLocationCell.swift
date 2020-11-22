//
//  WeatherLocationCell.swift
//  ozweather
//
//  Created by Xuwei Liang on 21/11/20.
//

import UIKit

protocol WeatherLocationCellDelegate {
    func delete(vm: WeatherLocationCellVM)
    func weatherForecast(vm: WeatherLocationCellVM)
}

class WeatherLocationCell: UITableViewCell {
    
    static let identifier: String = "WeatherLocationCell"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var deleteIcon: UIImageView!
    var delegate: WeatherLocationCellDelegate?
    
    var viewModel = WeatherLocationCellVM(text: "", type: .city)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupControl()
    }
    
    private func setupUI() {
        let theme: ThemeProtocol = AppData.shared.theme
        containerView.backgroundColor = theme.secondaryColor
        title.textColor = theme.primaryTextColor
    }
    
    private func setupControl() {
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(weatherForecast)))
        deleteIcon.isUserInteractionEnabled = true
        deleteIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteFromCache)))
    }
    
    @objc private func deleteFromCache() {
        guard let delegate = self.delegate else { return }
        delegate.delete(vm: self.viewModel)
    }
    
    @objc private func weatherForecast() {
        guard let delegate = self.delegate else { return }
        delegate.weatherForecast(vm: self.viewModel)
    }
    
    // we always clear the content on cell before re-use
    override func prepareForReuse() {
        // reset title
        title.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupUI()
    }
}

extension WeatherLocationCell: TableViewCellProtocol {
    
    func setupWith(_ vm: TableViewCellVMProtocol) {
        guard let viewModel = vm as? WeatherLocationCellVM else { return }
        title.text = viewModel.text
        self.viewModel = viewModel
    }
}
