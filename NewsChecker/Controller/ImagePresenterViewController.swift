//
//  ImagePresenterViewController.swift
//  NewsChecker
//
//  Created by Александр on 14.05.2021.
//

import UIKit

class ImagePresenterViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    var presentingImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = presentingImage
    }
    
}
