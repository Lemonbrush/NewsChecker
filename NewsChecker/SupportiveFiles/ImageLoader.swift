//
//  File.swift
//  NewsChecker
//
//  Created by Александр on 14.05.2021.
//

import UIKit

class ImageLoader {
    
    var cache: NSCache<NSString, UIImage>!
    
    init() {
        self.cache = NSCache()
    }
    
    func obtainImageWithPath(imagePath: String, completionHandler: @escaping (UIImage) -> ()) {
        if let image = self.cache.object(forKey: imagePath as NSString) {
            
            //If the image is cached
            DispatchQueue.main.async {
                completionHandler(image)
            }
            
        } else {
            
            let placeholder = UIImage(named: "Placeholder")! //Image for loading 
            
            DispatchQueue.main.async {
                completionHandler(placeholder)
            }
            
            let url: URL! = URL(string: imagePath)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if let data = try? Data(contentsOf: url) {
                    
                    let img: UIImage! = UIImage(data: data)
                    
                    //Cache this image
                    self.cache.setObject(img, forKey: imagePath as NSString)
                    
                    DispatchQueue.main.async {
                        completionHandler(img)
                    }
                }
            }
            
            task.resume()
        }
    }
}
