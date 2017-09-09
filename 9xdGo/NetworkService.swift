//
//  NetworkService.swift
//  9xdGo
//
//  Created by 이규진 on 2017. 9. 9..
//  Copyright © 2017년 이재성. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

class NetworkService {
    static let shared = NetworkService()

    private let baseURL = "http://uyu423.iptime.org:8000/"
    
    typealias JSONResultHandler = ((_ json: Any) -> Void)?
    typealias BooleanResultHandler = ((Bool) -> Void)?
    
    func postFacebookSign(id: String, token: String, name: String, imageURL: String, _ completion: JSONResultHandler) {
        let url = baseURL + "user/sign"
        let params: Parameters = [
            "fbId" : id,
            "thumbnailUrl" : imageURL,
            "authToken" : token,
            "name" : name
        ]
        print("url : " + url)
        print("params : " + params.debugDescription)
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response) in
                print(response.debugDescription)
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let success = json["success"].boolValue
                    if success {
                        // sign success
                        if let completion = completion {
                            completion(json["data"])
                        }
                    } else {
                        // sign failure
                    }
                case .failure(let error):
                    // request fail
                    print(error.localizedDescription)
                }
        }
    }
}
