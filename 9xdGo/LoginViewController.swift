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
    
    private let profileImageSize = CGSize(width: 200, height: 200)

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        // set facebook login permission
        loginButton.readPermissions = ["public_profile", "email"]
        loginButton.delegate = self
        
        if let accessToken = FBSDKAccessToken.current() {
            // login success
            print("Facebook Login token : " + accessToken.tokenString)
            print("ID : " + accessToken.userID)
            print("permissions : " + accessToken.permissions.debugDescription)
        }
        
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveCurrentProfile(notification:)), name: NSNotification.Name.FBSDKProfileDidChange, object: nil)
    }
    
    func didReceiveCurrentProfile(notification: NSNotification) {
        if let profile = FBSDKProfile.current() {
            print("profile")
            print("name : " + profile.name)
            print("imageURL : " + profile.imageURL(for:.square , size: profileImageSize).absoluteString)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
