//
//  ArticleWebViewController.swift
//  NewsChecker
//
//  Created by Александр on 14.05.2021.
//

import WebKit

class ArticleWebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var url: String!
    
    //Replace regular view with web view
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load the Article
        let url = URL(string: url)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
}
