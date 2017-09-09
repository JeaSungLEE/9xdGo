//
//  LoginViewController.swift
//  9xdGo
//
//  Created by 이규진 on 2017. 9. 9..
//  Copyright © 2017년 이재성. All rights reserved.
//

import UIKit

import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    let profileImageSize = CGSize(width: 200, height: 200)
    var isLogin = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        // set facebook login permission
        loginButton.readPermissions = ["public_profile", "email"]
        loginButton.delegate = self
        
        signFacebook()
        
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveCurrentProfile(notification:)), name: NSNotification.Name.FBSDKProfileDidChange, object: nil)
    }
    
    func signFacebook() {
        if let accessToken = FBSDKAccessToken.current(),
            let profile = FBSDKProfile.current(),
            self.isLogin == false {
            // login success
            let myInfo = UserInfo(
                fbId: accessToken.userID,
                authToken: accessToken.tokenString,
                name: profile.name,
                thumnailURLStr: profile.imageURL(for: .square, size: profileImageSize).absoluteString
            )
            UserInfoService.shared.myInfo = myInfo
            UserInfoService.shared.sign()
            self.isLogin = true
            
            // TODO: - Show MapStoryBoard
        }
    }
    
    func didReceiveCurrentProfile(notification: NSNotification) {
        signFacebook()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        print("loginButtonWillLogin")
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("loginButtonDidLogOut")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print("facebook login error : \(error.localizedDescription)")
        } else if result.isCancelled {
            print("facebook login cancelled")
        } else {
            print("facebook login succeeded")
        }
    }
}
