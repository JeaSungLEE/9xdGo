//
//  UserInfoService.swift
//  9xdGo
//
//  Created by 이규진 on 2017. 9. 9..
//  Copyright © 2017년 이재성. All rights reserved.
//

import Foundation

struct UserInfo {
    let fbId: String
    let authToken: String
    let name: String
    let thumnailURLStr: String
}

class UserInfoService {
    static let shared = UserInfoService()
    
    var myInfo: UserInfo!
    
    func sign() {
        NetworkService.shared.postFacebookSign(
            id: myInfo.fbId,
            token: myInfo.authToken,
            name: myInfo.name,
            imageURL: myInfo.thumnailURLStr
        )
    }
}
