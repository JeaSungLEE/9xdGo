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
    
    private func request(url: String, method: HTTPMethod, encoding: ParameterEncoding, params: [String : Any], completion: JSONResultHandler) {
        print("url : " + url)
        print("params : " + params.debugDescription)
        Alamofire.request(url, method: method, parameters: params, encoding: encoding, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    print(value)
                    let json = JSON(value)
                    let success = json["success"].boolValue
                    if success {
                        if let completion = completion {
                            completion(json["data"].object)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    func postFacebookSign(id: String, token: String, name: String, imageURL: String, _ completion: JSONResultHandler) {
        let url = baseURL + "user/sign"
        let params: Parameters = [
            "fbId" : id,
            "thumbnailUrl" : imageURL,
            "authToken" : token,
            "name" : name
        ]
        self.request(url: url, method: .post, encoding: JSONEncoding.default, params: params, completion: completion)
    }
}
