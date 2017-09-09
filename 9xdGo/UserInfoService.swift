//
//  UserInfoService.swift
//  9xdGo
//
//  Created by 이규진 on 2017. 9. 9..
//  Copyright © 2017년 이재성. All rights reserved.
//

import Foundation

import FBSDKLoginKit

struct UserInfo {
    let fbId: String
    let authToken: String
    let name: String
    let thumnailURLStr: String
}

protocol UserInfoServiceDelegate: class {
    func userInfo(didUpdateUserInfo userInfo: UserInfo)
}

class UserInfoService {
    static let shared = UserInfoService()
    weak var delegate: UserInfoServiceDelegate?
    
    private let profileImageSize = CGSize(width: 200, height: 200)
    
    var myInfo: UserInfo! {
        didSet(userInfo) {
            delegate?.userInfo(didUpdateUserInfo: self.myInfo)
        }
    }
    
    func fetchUserInfo(accessToken: FBSDKAccessToken, profile: FBSDKProfile) {
        let myInfo = UserInfo(
            fbId: accessToken.userID,
            authToken: accessToken.tokenString,
            name: profile.name,
            thumnailURLStr: profile.imageURL(for: .square, size: profileImageSize).absoluteString
        )
        UserInfoService.shared.myInfo = myInfo
    }
    
}
