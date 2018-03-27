//
//  TTAPIClient.swift
//  Top10
//
//  Created by Muluken Gebremariam on 11/2/17.
//  Copyright © 2017 Keeple. All rights reserved.
//

import UIKit
import Alamofire

class TTAPIClient: NSObject {
    
    static let sharedInstance = TTAPIClient()
    
    private override init() {}
    
    func sendGetRequest(path: String, completion: @escaping (_ jsonResonse: DataResponse<Any>) -> Void) {
        Alamofire.request(path).responseJSON { response in
            completion(response);
        }
    }
}
