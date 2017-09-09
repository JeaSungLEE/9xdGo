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
    
    private var index = 0
    private let profileViewHeight: CGFloat = 200
    private let productArray: [UIImage] = [#imageLiteral(resourceName: "product"), #imageLiteral(resourceName: "product1"), #imageLiteral(resourceName: "product2")]
    private let productNameArray: [String] = ["Yellow Hood", "Stickers", "Long MousePad"]
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makePins()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(red: 44/255.0, green: 43/255.0, blue: 43/255.0, alpha: 1)
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = .white
        
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
