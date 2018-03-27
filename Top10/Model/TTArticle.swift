//
//  TTArticle.swift
//  Top10
//
//  Created by Muluken Gebremariam on 11/1/17.
//  Copyright © 2017 Keeple. All rights reserved.
//

import UIKit

class TTArticle: NSObject {
    var section: String?
    var title: String?
    var abstract: String?
    var url: String?
    var frontImageUrl: String?
    var imageUrlList: [String]?
    
    init?(dict: [String: Any]) {
        guard let title = dict["title"] as? String,
            let section = dict["section"] as? String,
            let abstract = dict["abstract"] as? String,
            let url = dict["url"] as? String
            else {
                return nil
        }
        
        self.title = title
        self.section = section
        self.abstract = abstract
        self.url = url
        if let mediaList = dict["multimedia"] as? [Any] {
            var urlList = [String]()
            for media in mediaList as! [[String: Any]] {
                
                if media["type"] as! String == "image" {
                    urlList.append(media["url"] as! String)
                    if(media["format"] as! String == "superJumbo") {
                        self.frontImageUrl = media["url"] as? String
                    }
                }
            }

            self.imageUrlList = urlList

        }
        
    }
    
    init?(fromPlist dict: [String: Any]) {
        guard let title = dict["title"] as? String,
            let section = dict["section"] as? String,
            let abstract = dict["abstract"] as? String,
            let url = dict["url"] as? String
            else {
                return nil
        }
        
        self.title = title
        self.section = section
        self.abstract = abstract
        self.url = url
        self.frontImageUrl = dict["frontImageUrl"] as? String
        self.imageUrlList = dict["imageUrlList"] as? [String]
        
    }
    
    func toDictionary() -> [String: Any]? {
        guard let title = self.title,
            let section = self.section,
            let abstract = self.abstract,
            let url = self.url
            else {
                return nil
        }
        
        var dict = [String: Any]()
        
        dict["title"] = title
        dict["section"] = section
        dict["abstract"] = abstract
        dict["url"] = url
        dict["frontImageUrl"] = self.frontImageUrl
        dict["imageUrlList"] = self.imageUrlList
        
        return dict
    }
}
