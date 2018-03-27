//
//  TTArticleDetailViewController.swift
//  Top10
//
//  Created by Muluken Gebremariam on 11/5/17.
//  Copyright © 2017 Keeple. All rights reserved.
//

import UIKit
import WebKit

class TTArticleDetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var article: TTArticle?
    var date: Date?
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let displayedArticle = self.article {
            if let articleDate = self.date {
                TTUtil.markArticleRead(displayedArticle, date: articleDate)
            }
        }

        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        if let newsArticle = self.article {
            if let urlString = newsArticle.url {
                let url = URL(string:urlString)
                let urlRequest = URLRequest(url: url!)
                webView.load(urlRequest)
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - WKNavigationDelegate methods
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
}
