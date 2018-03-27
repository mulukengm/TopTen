//
//  TTArticleDetailViewController.swift
//  Top10
//
//  Created by Muluken Gebremariam on 11/5/17.
//  Copyright © 2017 Keeple. All rights reserved.
//

import UIKit

class TTArticlePageViewController: UIPageViewController, UIPageViewControllerDelegate {

    var articles = [TTArticle]()
    var articleIndex: Int?
    var date: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        addBackButton()
        
        if let currentArticleIndex = articleIndex {
            if articles.indices.contains(currentArticleIndex) {
                let article = articles[currentArticleIndex]
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller: TTArticleDetailViewController = storyboard.instantiateViewController(withIdentifier: "TTArticleDetailViewController") as! TTArticleDetailViewController
                controller.article = article
                controller.date = self.date
                
                setViewControllers([controller], direction: .forward, animated: true, completion: nil)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addBackButton(){
        let backButton = UIButton.init(type: .custom)
        backButton.frame = CGRect(x: 0, y: 18, width: 56, height: 56)
        backButton.setImage(UIImage.init(named: "circleBackButton"), for: .normal)
        backButton.addTarget(self, action:#selector(backAction(sender:)), for: .touchUpInside)
        self.view.addSubview(backButton)
    }
    
    @objc func backAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TTArticlePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let articleDetailViewController = viewController as! TTArticleDetailViewController
        
        guard let article = articleDetailViewController.article else {
            return nil
        }
        
        guard let articleIndex = self.articles.index(of: article) else {
            return nil
        }
        
        let previousArticleIndex = articleIndex - 1

        guard self.articles.count > previousArticleIndex,
        previousArticleIndex >= 0
        else {
            return nil
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: TTArticleDetailViewController = storyboard.instantiateViewController(withIdentifier: "TTArticleDetailViewController") as! TTArticleDetailViewController
        controller.article = articles[previousArticleIndex]
        controller.date = self.date
        
        return controller
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let articleDetailViewController = viewController as! TTArticleDetailViewController
        
        guard let article = articleDetailViewController.article else {
            return nil
        }
        
        guard let articleIndex = self.articles.index(of: article) else {
            return nil
        }
        
        let nextArticleIndex = articleIndex + 1
        
        guard self.articles.count > nextArticleIndex,
            nextArticleIndex >= 0
            else {
                return nil
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: TTArticleDetailViewController = storyboard.instantiateViewController(withIdentifier: "TTArticleDetailViewController") as! TTArticleDetailViewController
        controller.article = articles[nextArticleIndex]
        controller.date = self.date
        
        return controller
    }
    
    
}
