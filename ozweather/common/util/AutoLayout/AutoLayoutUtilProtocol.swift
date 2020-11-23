//
//  AutoLayoutUtil.swift
//  ozweather
//
//  Created by Xuwei Liang on 23/11/20.
//

import UIKit

protocol AutoLayoutUtilProtocol {
    func pinToSuperView (_ view: UIView, left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat)
    func pinToSuperviewCenter(_ view: UIView, width: CGFloat, height: CGFloat)
}
