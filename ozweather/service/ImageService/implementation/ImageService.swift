//
//  ImageService.swift
//  ozweather
//
//  Created by Xuwei Liang on 23/11/20.
//

import UIKit

class ImageService: ImageServiceProtocol {

    static let shared = ImageService()
    private let imageLoaderSession = URLSession(configuration: .default)
    private init() { }
    
    func loadImage(from urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { completionHandler(nil); return }
        
        let dataTask = imageLoaderSession.dataTask(with: url) { data, _, _ in
            guard let data = data else { completionHandler(nil); return }
            guard let image = UIImage(data: data) else { completionHandler(nil); return }
            // return image
            completionHandler(image)
        }
        
        dataTask.resume()
    }
}
