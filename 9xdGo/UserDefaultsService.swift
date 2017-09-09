//
//  UserDefaultsService.swift
//  9xdGo
//
//  Created by 이규진 on 2017. 9. 9..
//  Copyright © 2017년 이재성. All rights reserved.
//

import Foundation

class UserDefaultsService {
    static let shared = UserDefaultsService()
    let standard = UserDefaults.standard

    enum UserDefaultsType {
        case isLogin
        case id
        
        func key() -> String {
            switch self {
            case .isLogin:
                return "isLogin"
            case .id:
                return "id"
            }
        }
    }
    
    var isLogin: Bool {
        get {
            return standard.bool(forKey: UserDefaultsType.isLogin.key())
        }
        set {
            standard.set(newValue, forKey: UserDefaultsType.isLogin.key())
        }
    }
    
    var id: String {
        get {
            return standard.string(forKey: UserDefaultsType.id.key()) ?? ""
        }
        set {
            standard.set(newValue, forKey: UserDefaultsType.id.key())
        }
    }
}
