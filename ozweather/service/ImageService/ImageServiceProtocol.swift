//
//  ImageServiceProtocol.swift
//  ozweather
//
//  Created by Xuwei Liang on 23/11/20.
//

import UIKit

protocol ImageServiceProtocol {
    func loadImage(from urlString: String, completionHandler: @escaping (UIImage?)->Void)
}
