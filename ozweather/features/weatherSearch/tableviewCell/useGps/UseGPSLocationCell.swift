//
//  UseGPSLocationCell.swift
//  ozweather
//
//  Created by Xuwei Liang on 21/11/20.
//

import UIKit

protocol UseGPSLocationCellDelegate {
    func useCurrentLocation(vm: UseGPSLocationCellVM)
}

class UseGPSLocationCell: UITableViewCell {

    static let identifier: String = "UseGPSLocationCell"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var containerView: UIView!
    var delegate: UseGPSLocationCellDelegate?
    
    var viewModel = UseGPSLocationCellVM(title: "", caption: "")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        let theme: ThemeProtocol = AppData.shared.theme
        containerView.backgroundColor = theme.primaryColor
        title.textColor = theme.primaryTextColor
        caption.textColor = theme.primaryTextColor
    }
    
    private func setupControl() {
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(useGPSLocation)))
    }
    
    @objc private func useGPSLocation() {
        guard let delegate = self.delegate else { return }
        delegate.useCurrentLocation(vm: self.viewModel)
    }
    
    // we always clear the content on cell before re-use
    override func prepareForReuse() {
        // reset title
        title.text = ""
        caption.text = ""
    }
}

extension UseGPSLocationCell: TableViewCellProtocol {
    func setupWith(_ vm: TableViewCellVMProtocol) {
        guard let viewModel = vm as? UseGPSLocationCellVM else { return }
        self.title.text = viewModel.title
        self.caption.text = viewModel.caption
        self.viewModel = viewModel
    }
}
