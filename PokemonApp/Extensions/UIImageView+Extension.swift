//
//  UIImageView+Extension.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 13/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import UIKit
import Alamofire

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    /// Assigns the placeholder image to the image view and starts the download of the image in asynchronous. If the image is correctly downloaded, then replaces the placeholder.
    /// - Parameters:
    ///   - urlString: The url of the image.
    ///   - placeholder: The placeholder image.
    func loadImageUrl(_ url: URL?, placeholder: UIImage?) {
        if let placeholder = placeholder {
            image = placeholder
        }
        
        guard let url = url else { return }
        
        // Check if the image is already cached
        if let image = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = image
            return
        }
        
        Alamofire.request(url).validate().responseData { [weak self] (response) in
            if !response.result.isSuccess {
                // TODO: Handle error
                return
            }
            
            if let data = response.data, let image = UIImage(data: data) {
                // Save image in cache
                imageCache.setObject(image, forKey: url.absoluteString as AnyObject)
                
                DispatchQueue.main.async() {
                    self?.image = image
                }
            }
        }
    }

}
