//
//  WeatherLocationCell.swift
//  ozweather
//
//  Created by Xuwei Liang on 21/11/20.
//

import UIKit

class WeatherLocationCell: UITableViewCell {
    
    static let identifier: String = "WeatherLocationCell"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var viewModel = WeatherLocationVM(text: "", type: .city)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let theme: ThemeProtocol = AppData.shared.theme
        containerView.backgroundColor = theme.backgroundColor
        title.textColor = theme.primaryColor
    }
}
