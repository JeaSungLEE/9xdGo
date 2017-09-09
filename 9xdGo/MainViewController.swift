//
//  MainViewController.swift
//  9xdGo
//
//  Created by 이재성 on 09/09/2017.
//  Copyright © 2017 이재성. All rights reserved.
//

import UIKit
import CoreLocation
import FBSDKLoginKit

class MainViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var mapImageView: UIImageView!
    @IBOutlet var chattingImageView: UIImageView!
    @IBOutlet var purchaseButton: UIButton!
    @IBOutlet var completeLabel: UILabel!
    @IBOutlet var 테두리이미지: UIImageView!
    
    private var index = 0
    private let profileViewHeight: CGFloat = 200
    private let productArray: [UIImage] = [#imageLiteral(resourceName: "product"), #imageLiteral(resourceName: "product1"), #imageLiteral(resourceName: "product2")]
    private let productNameArray: [String] = ["Yellow Hood", "Stickers", "Long MousePad"]
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var firstBackTop: NSLayoutConstraint!
    @IBOutlet var firstBackRight: NSLayoutConstraint!
    @IBOutlet var firstBackLeft: NSLayoutConstraint!
    @IBOutlet var firstBackBottom: NSLayoutConstraint!
    
    @IBOutlet var secondBackTop: NSLayoutConstraint!
    @IBOutlet var secondBackRight: NSLayoutConstraint!
    @IBOutlet var secondBackBottom: NSLayoutConstraint!
    @IBOutlet var secondBackLeft: NSLayoutConstraint!
    
    @IBOutlet var starBottom: NSLayoutConstraint!
    @IBOutlet var starTop: NSLayoutConstraint!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makePins()
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 5
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.secondBackTop.constant = -80
        self.secondBackBottom.constant = 0
        self.secondBackLeft.constant = -getScreenSize().width
        self.secondBackRight.constant = getScreenSize().width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isLogin() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(controller, animated: true, completion: nil)
        } else {
            UserInfoService.shared.delegate = self
            UserDefaultsService.shared.id = 0
            if let accessToken = FBSDKAccessToken.current(),
                let profile = FBSDKProfile.current() {
                UserInfoService.shared.fetchUserInfo(accessToken: accessToken, profile: profile)
            }
        }
//        
//        UIView.animate(withDuration: 2, delay: 0, options: [.repeat, .autoreverse], animations: {
//            self.starTop.constant = -10
//            self.starBottom.constant = 10
//            self.view.layoutIfNeeded()
//        }) { (t) in
//            self.starTop.constant = 0
//            self.starBottom.constant = 0
//            self.view.layoutIfNeeded()
//        }
//        
        UIView.animate(withDuration: 20, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.firstBackTop.constant = 0
            self.firstBackBottom.constant = -80
            self.firstBackLeft.constant = getScreenSize().width
            self.firstBackRight.constant = -getScreenSize().width
            
            self.secondBackTop.constant = 0
            self.secondBackBottom.constant = -80
            self.secondBackLeft.constant = 0
            self.secondBackRight.constant = 0
            self.view.layoutIfNeeded()
        })
        { (t) in
            self.firstBackTop.constant = -80
            self.firstBackBottom.constant = 0
            self.firstBackLeft.constant = 0
            self.firstBackRight.constant = 0
            
            self.secondBackTop.constant = -80
            self.secondBackBottom.constant = 0
            self.secondBackLeft.constant = -getScreenSize().width
            self.secondBackRight.constant = getScreenSize().width
            self.view.layoutIfNeeded()
        }
    }
    
    private func makePins() {
        let pinList = PinList.init(mapHeight: getScreenSize().height - profileViewHeight)
        
        for pinItem in pinList.pinList {
            setPin(pinItem: pinItem)
        }
    }
    
    private func setPin(pinItem: PinModel) {
        let pin = UIButton(type: .custom)
        pin.setBackgroundImage(pinItem.image, for: .normal)
        pin.frame = CGRect(origin: .zero, size: pinItem.size)
        pin.tag = index
        
        pin.addTarget(self, action: #selector(self.selectPin(_:)), for: .touchUpInside)
        index += 1
        
        pin.center = pinItem.point
        
        mapImageView.addSubview(pin)
    }
    
    func selectPin(_ sender: UIButton) {
        completeLabel.isHidden = true
        profileImageView.isHidden = false
        profileName.isHidden = false
        purchaseButton.isHidden = false
        테두리이미지.isHidden = false
        
        let index = sender.tag
        
        profileImageView.image = productArray[index]
        profileName.text = productNameArray[index]
    }
    
    private func isLogin() -> Bool {
        if FBSDKAccessToken.current() != nil {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func purchaseButtonAction(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        controller.image = profileImageView.image
        controller.productName = profileName.text
        self.present(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}

extension MainViewController: UserInfoServiceDelegate {
    func userInfo(didUpdateUserInfo userInfo: UserInfo) {
        // update ui
        print("user info : \(userInfo)")
    }
}
