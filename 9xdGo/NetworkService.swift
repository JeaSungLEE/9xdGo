//
//  NetworkService.swift
//  9xdGo
//
//  Created by 이규진 on 2017. 9. 9..
//  Copyright © 2017년 이재성. All rights reserved.
//

import Foundation

import Alamofire

class NetworkService {
    static let shared = NetworkService()

    private let baseURL = "http://uyu423.iptime.org:8000/"
    
    func postFacebookSign(id: String, token: String, name: String, imageURL: String) {
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
        }
    }
}
