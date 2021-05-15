//
//  PostViewController.swift
//  NewsChecker
//
//  Created by Александр on 14.05.2021.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDescriptionLabel: UILabel!
    @IBOutlet weak var readButton: UIButton!
    
    let imageLoader = ImageLoader()
    var articleTitle: String!
    var articleDescription: String!
    var imageURL: String?
    var articleURL: String!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up button
        readButton.layer.cornerRadius = 20
        readButton.layer.cornerCurve = CALayerCornerCurve.continuous

        //Setting up text and the image
        articleTitleLabel.text = articleTitle
        articleDescriptionLabel.text = articleDescription
        
        if let safeImageURL = imageURL {
            
            //Lazy load image
            imageLoader.obtainImageWithPath(imagePath: safeImageURL) { image in
                self.postImage.image = image
            }
            
            //Make image tappable
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            postImage.isUserInteractionEnabled = true
            postImage.addGestureRecognizer(tapGestureRecognizer)
        }
        
    }
    
    //Show image on tap
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let imagePresenter = storyboard?.instantiateViewController(identifier: C.imagePresenterVCid) as! ImagePresenterViewController
        imagePresenter.presentingImage = tappedImage.image
        
        present(imagePresenter, animated: true, completion: nil)
        
    }
    
    @IBAction func readButtonPressed(_ sender: Any) {
        let articleWebViewController = ArticleWebViewController()
        articleWebViewController.url = articleURL
        
        navigationController?.pushViewController(articleWebViewController, animated: true)
    }
    
}
