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
        setupUI()
    }
    
    private func setupUI() {
        let theme: ThemeProtocol = AppData.shared.theme
        containerView.backgroundColor = theme.secondaryColor
        title.textColor = theme.primaryTextColor
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
        guard let viewModel = vm as? WeatherLocationVM else { return }
        title.text = viewModel.text
        self.viewModel = viewModel
    }
    
}
