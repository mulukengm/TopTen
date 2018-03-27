//
//  TTConstant.swift
//  Keemory
//
//  Created by Muluken Gebremariam on 10/19/17.
//  Copyright © 2017 Keeple. All rights reserved.
//

import Foundation
import UIKit

struct  TTData {
    static let articlesLimit = 10
}
struct TTUserDefaultsKey {
    static let darkTheme = "DARK_THEME_KEY"
}

struct NYTimesAPI {
    static let apiKey = "191e2b769a6a484a8d2fdd12f6949a8c"//"01261d7da7424e31ab83a5f1db691644"
    static let apiPath = "http://api.nytimes.com/svc"
    static let mostViewedArticlesPath = "topstories/v2"
}

struct TTColor {
    static let color1 = UIColor.init(red: 250/255.0, green: 125/255.0, blue: 7/255.0, alpha: 1)
    static let color2 = UIColor.init(red: 222/255.0, green: 168/255.0, blue: 0, alpha: 1)
    static let color3 = UIColor.init(red: 193/255.0, green: 18/255.0, blue: 219/255.0, alpha: 1)
    static let color4 = UIColor.init(red: 0, green: 182/255.0, blue: 9/255.0, alpha: 1)
    static let color5 = UIColor.init(red: 20/255.0, green: 163/255.0, blue: 135/255.0, alpha: 1)
    static let color6 = UIColor.init(red: 9/255.0, green: 169/255.0, blue: 255/255.0, alpha: 1)
}

struct TTPath {
    static let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    static let historyPList = "history.plist"
}
