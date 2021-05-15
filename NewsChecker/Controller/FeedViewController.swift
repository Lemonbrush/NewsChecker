//
//  ViewController.swift
//  NewsChecker
//
//  Created by Александр on 14.05.2021.
//

import CoreData
import UIKit

class FeedViewController: UIViewController, NetworkingManagerDelegate {
    
    //CoreData container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var newsTable: UITableView!
    
    var refreshControl = UIRefreshControl()
    var imageLoader = ImageLoader() //Lazy loading manager
    
    var posts = [PostModel?]()
    var networkManager = NetworkManager()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The path to the local directory on the device to store App data
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
    
    //MARK: - CoreData methods
    func savePosts(_ posts: [PostModel?]) {
        
        for post in posts {
            let newPost = PostEntity(context: self.context)
            newPost.category = post?.category
            newPost.postDescription = post?.description
            newPost.title = post?.title
            newPost.url = post?.url
            newPost.imageUrl = post?.image
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
    }
    
    func updateSavedPosts(_ posts: [PostModel?]) {
        resetSavedEntities(withName: "PostEntity")
        savePosts(posts)
    }
    
    func resetSavedEntities(withName entityName: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Fail to reset entities with error, \(error)")
        }
    }

}

//MARK: - NetworkManager delegate
extension FeedViewController {
    
    func didUpdate(_ networkManager: NetworkManager, posts: [PostModel]) {
        
        DispatchQueue.main.async {
            self.posts = posts
            self.updateSavedPosts(posts)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: C.newsCellId, for: indexPath) as! PostCell
        
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
        
        if let viewController = storyboard?.instantiateViewController(identifier: C.postVCid) as? PostViewController {
            
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



