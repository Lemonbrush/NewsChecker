//
//  ViewController.swift
//  NewsChecker
//
//  Created by Александр on 14.05.2021.
//

import UIKit

class FeedViewController: UIViewController, NetworkingManagerDelegate {
    
    @IBOutlet weak var newsTable: UITableView!
    
    var refreshControl = UIRefreshControl()
    var imageLoader = ImageLoader() //Lazy loading
    
    var posts = [PostModel?]()
    var networkManager = NetworkManager()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //RefreshControl settings
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshPostsData(_:)), for: .valueChanged)
        newsTable.backgroundView = refreshControl
        
        networkManager.delegate = self
        
        networkManager.fetchNewsData()
    }
    
    //Pull-To-Refresh tableview
    @objc func refreshPostsData(_ sender: AnyObject) {
        networkManager.fetchNewsData()
        refreshControl.endRefreshing()
    }

}

//MARK: - NetworkManager delegate
extension FeedViewController {
    
    func didUpdate(_ networkManager: NetworkManager, posts: [PostModel]) {
        
        DispatchQueue.main.async {
            self.posts = posts
            self.newsTable.reloadData()
        }
    }
    
    //Error handle
    func didFailWithError(error: Error) {
        DispatchQueue.main.sync {
            
            let alert = UIAlertController(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in }

            alert.addAction(action)
        
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - TableView delegates
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! PostCell
        
        let postToShow = posts[indexPath.row]
        
        cell.articleTitle.text = postToShow?.title
        cell.category.text = postToShow?.category
        
        //Lazyly fetch image via imageLoader
        if let imageURL = postToShow?.image {
            imageLoader.obtainImageWithPath(imagePath: imageURL) { image in
                cell.articleImage.image = image
            }
        } else {
            //Set default image
            cell.articleImage.image = UIImage(named: "Placeholder")!
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let viewController = storyboard?.instantiateViewController(identifier: "PostVC") as? PostViewController {
            
            let selectedPost = posts[indexPath.row]
            
            viewController.articleDescription = selectedPost?.description
            viewController.articleTitle = selectedPost?.title
            viewController.imageURL = selectedPost?.image
            viewController.articleURL = selectedPost?.url
            viewController.title = selectedPost?.category
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



