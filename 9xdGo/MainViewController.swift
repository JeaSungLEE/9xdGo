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
import SwiftyJSON
import SDWebImage

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
    
    var dataSource: [Place] = []
    
    let locationManager = CLLocationManager()
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isLogin() {
            UserDefaultsService.shared.id = 0
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(controller, animated: true, completion: nil)
        } else {
            UserInfoService.shared.delegate = self
            if let accessToken = FBSDKAccessToken.current(),
                let profile = FBSDKProfile.current() {
                UserInfoService.shared.fetchUserInfo(accessToken: accessToken, profile: profile)
            }
            self.requestPlace()
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
        
        guard self.dataSource.count > 0,
            let product = dataSource[index].products.first else { return }
        profileImageView.sd_setImage(with: product.imageURL)
        profileName.text = product.name
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
    
    func requestPlace() {
        let userId = UserDefaultsService.shared.id
        print("request plase userid = \(userId)")
        if userId != 0 {
            NetworkService.shared.getPlace(userId: userId, { [weak self] (data) in
                guard let `self` = self else { return }
                let json = JSON(data)
                self.dataSource = json.arrayValue.map { Place(json: $0) }
            })
        }
    }
    
}

extension MainViewController: UserInfoServiceDelegate {
    func userInfo(didUpdateUserInfo userInfo: UserInfo) {
        // update ui
        print("user info : \(userInfo)")
    }
}
