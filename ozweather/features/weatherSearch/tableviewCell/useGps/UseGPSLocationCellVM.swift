//
//  UseGPSLocationVM.swift
//  ozweather
//
//  Created by Xuwei Liang on 21/11/20.
//

import Foundation

struct UseGPSLocationCellVM: TableViewCellVMProtocol {
    let identifier = UseGPSLocationCell.identifier
    let title: String
    let caption: String
    let locationServiceActive: Bool
    
}
