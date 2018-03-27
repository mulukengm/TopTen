//
//  Util.swift
//  Top10
//
//  Created by Muluken Gebremariam on 11/6/17.
//  Copyright © 2017 Keeple. All rights reserved.
//

import UIKit

class TTUtil: NSObject {
    static func markArticleRead(_ article:TTArticle, date:Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from:date)
        
        var readArticlesDictionary = [String:Any]()
        if let dictionary = UserDefaults.standard.dictionary(forKey: dateString) {
            readArticlesDictionary = dictionary
        }
        
        readArticlesDictionary[article.url!] = true
        UserDefaults.standard.setValue(readArticlesDictionary, forKey: dateString)
    }
    
    static func isArticleRead(_ article:TTArticle, date:Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from:date)
        
        if let dictionary = UserDefaults.standard.dictionary(forKey: dateString) as? [String : Bool] {
            if let urlString = article.url {
                if let isRead = dictionary[urlString]  {
                    return isRead
                }
            }
        }
        
        return false
    }
    
    static func saveArticlesToHistory(_ articles: [TTArticle], date:Date) {
        let documentsDirectory = TTPath.documents
        let historyPlistPath = (documentsDirectory as NSString).appendingPathComponent(TTPath.historyPList)
        let fileManager = FileManager.default
        
        var dictionary = NSMutableDictionary.init()
        
        if fileManager.fileExists(atPath: historyPlistPath) {
            dictionary = NSMutableDictionary(contentsOfFile: historyPlistPath)!
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from:date)
        
        var articlesDictList = [[String: Any]]()
        for case let article in articles {
            if let articleDict = article.toDictionary() {
                articlesDictList.append(articleDict)
            }
        }
        
        dictionary.setValue(articlesDictList, forKey: dateString)
        
        let succeed = dictionary.write(toFile: historyPlistPath, atomically: true)
        if succeed {
            print("Articles saved successfully")
        }
        else {
            print("Error saving articles")
        }
    }
    
    static func articles(forDate date:Date) -> [TTArticle]? {

        if let fileUrl = NSURL(fileURLWithPath: TTPath.documents).appendingPathComponent(TTPath.historyPList),
            let data = try? Data(contentsOf: fileUrl) {
            if let dict = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = dateFormatter.string(from:date)
                
                if let articlesDictList = dict![dateString] as? [[String: Any]] {
                    var articles = [TTArticle]()
                    
                    for case let articleDict in articlesDictList {
                        if let article = TTArticle(fromPlist: articleDict) {
                            articles.append(article)
                        }
                    }
                    return articles
                }
            }
        }
        
        return nil
    }
    
    static func availableArticleDates() -> [Date] {
        
        var dates = [Date]()
        if let fileUrl = NSURL(fileURLWithPath: TTPath.documents).appendingPathComponent(TTPath.historyPList),
            let data = try? Data(contentsOf: fileUrl) {
            if let resultDictionary = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let dateStringsList = Array(resultDictionary!.keys).sorted().reversed()
                
                for case let dateString in dateStringsList {
                    if let date = dateFormatter.date(from: dateString) {
                        dates.append(date)
                    }
                }

            }
        }
        
        return dates
    }
    
    static func colorFor(section: String) -> UIColor {
        switch section.lowercased() as NSString {
        case let x where x.range(of: "politics").length != 0:
            return TTColor.color1
        case let x where x.range(of: "home").length != 0:
            return TTColor.color2
        case let x where x.range(of: "opinion").length != 0:
            return TTColor.color3
        case let x where x.range(of: "world").length != 0:
            return TTColor.color4
        case let x where x.range(of: "business").length != 0:
            return TTColor.color5
        case let x where x.range(of: "u.s.").length != 0:
            return TTColor.color6
        case let x where x.range(of: "upshot").length != 0:
            return TTColor.color1
        case let x where x.range(of: "nyregion").length != 0:
            return TTColor.color2
        case let x where x.range(of: "national").length != 0:
            return TTColor.color3
        case let x where x.range(of: "technology").length != 0:
            return TTColor.color4
        case let x where x.range(of: "science").length != 0:
            return TTColor.color5
        case let x where x.range(of: "health").length != 0:
            return TTColor.color6
        case let x where x.range(of: "sports").length != 0:
            return TTColor.color1
        case let x where x.range(of: "books").length != 0:
            return TTColor.color2
        case let x where x.range(of: "arts").length != 0:
            return TTColor.color3
        case let x where x.range(of: "movies").length != 0:
            return TTColor.color4
        case let x where x.range(of: "theater").length != 0:
            return TTColor.color5
        case let x where x.range(of: "review").length != 0:
            return TTColor.color6
        case let x where x.range(of: "fashion").length != 0:
            return TTColor.color1
        case let x where x.range(of: "tmagazine").length != 0:
            return TTColor.color2
        case let x where x.range(of: "food").length != 0:
            return TTColor.color3
        case let x where x.range(of: "travel").length != 0:
            return TTColor.color4
        case let x where x.range(of: "magazine").length != 0:
            return TTColor.color5
        case let x where x.range(of: "realestate").length != 0:
            return TTColor.color6
        case let x where x.range(of: "automobiles").length != 0:
            return TTColor.color1
        case let x where x.range(of: "obituaries").length != 0:
            return TTColor.color2
        case let x where x.range(of: "insider").length != 0:
            return TTColor.color2
        default:
            return TTColor.color6
        }
    }
}
