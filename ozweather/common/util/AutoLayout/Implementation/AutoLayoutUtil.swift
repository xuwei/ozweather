//
//  AutoLayoutUtil.swift
//  ozweather
//
//  Created by Xuwei Liang on 23/11/20.
//

import UIKit

struct AutoLayoutUtil: AutoLayoutUtilProtocol {
    
    static let shared = AutoLayoutUtil()
    private init() {}
    
    func pinToSuperView (_ view: UIView, left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) {
        guard let superview = view.superview else { return }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: top)
        let left = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: left)
        let right = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: right)
        let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: bottom)
        superview.addConstraints([top, left, right, bottom])
    }
    
    func pinToSuperviewCenter(_ view: UIView, width: CGFloat, height: CGFloat) {
        guard let superview = view.superview else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        let vertical = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        let horizontal = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width)
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
        
        superview.addConstraints([vertical, horizontal, widthConstraint, heightConstraint])
    }
}
