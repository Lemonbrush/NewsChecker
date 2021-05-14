//
//  NetworkingManager.swift
//  NewsChecker
//
//  Created by Александр on 14.05.2021.
//

import UIKit

protocol NetworkingManagerDelegate {
    func didUpdate(_ networkManager: NetworkManager, posts: [PostModel])
    func didFailWithError(error: Error)
}

class NetworkManager: ObservableObject {
    let weatherBaseURL = "http://api.mediastack.com/v1/news?"
    let appid = "976c112ab645943f25291e006beb957a"
    
    var delegate: NetworkingManagerDelegate?
    
    //MARK: - Fetching news data
    
    func fetchNewsData() {
        let urlString = "\(weatherBaseURL)access_key=\(appid)&sources=en&limit=100"
        performRequest(with: urlString)
    }
    
    //MARK: - Networking
    
    func performRequest(with urlString: String) {
        
        // Getting rid of any spaces which ruins the whole thing
        let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        //Create a URL
        if let url = URL(string: encodedURLString) {
            
            //Create a URLSession
            let session = URLSession(configuration: .default) // The thing is like a web browser
            
            //Give the session a task
            //Complition handler is executed in background so it requares synchronizing
            let task = session.dataTask(with: url) { (data, response, error) in
                
                // Complition handler for URLSesstion task
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let posts = self.parseJSON(safeData) {
                        self.delegate?.didUpdate(self, posts: posts)
                    }
                }
            }
            
            //Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ postData: Data) -> [PostModel]? {
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode(PostData.self, from: postData)
            
            var news = [PostModel]()
            
            for data in decodedData.data {
                news.append(PostModel(title: data.title,
                                      category: data.category,
                                      description: data.description,
                                      url: data.url,
                                      image: data.image))
            }
            
            return news
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
