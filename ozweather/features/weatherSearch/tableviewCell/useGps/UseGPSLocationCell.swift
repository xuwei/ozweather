//
//  UseGPSLocationCell.swift
//  ozweather
//
//  Created by Xuwei Liang on 21/11/20.
//

import UIKit

class UseGPSLocationCell: UITableViewCell {
    
    static let identifier: String = "UseGPSLocationCell"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var viewModel = WeatherLocationVM(text: "", type: .gpsCoord)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let theme: ThemeProtocol = AppData.shared.theme
        containerView.backgroundColor = theme.primaryColor
        title.textColor = theme.secondaryColor
        caption.textColor = theme.secondaryColor
    }
}
