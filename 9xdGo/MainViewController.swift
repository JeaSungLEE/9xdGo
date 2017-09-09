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
    var pins: [UIButton] = []
    
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
        
        UIView.animate(withDuration: 20, delay: 0, options: [.repeat, .autoreverse, .curveLinear], animations: {
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
        self.pins.append(pin)
        
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
        self.updateProductView(product: product, isConquested: dataSource[index].isConquested)
    }
    
    func updateProductView(product: Product, isConquested: Bool) {
        if isConquested {
            profileImageView.sd_setImage(with: product.imageURL)
            profileName.text = product.name
            purchaseButton.isHidden = false
        } else {
            profileImageView.image = nil
            profileImageView.backgroundColor = .black
            profileName.text = "BLOCK"
            purchaseButton.isHidden = true
        }
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
        print("request place userid = \(userId)")
        if userId != 0 {
            NetworkService.shared.getPlace(userId: userId, { [weak self] (data) in
                guard let `self` = self else { return }
                let json = JSON(data)
                self.dataSource = json.arrayValue.map { Place(json: $0) }.sorted { $0.0.id < $0.1.id }
                self.updateConquest()
            })
        }
    }
    
    func updateConquest() {
        let name = UserInfoService.shared.myInfo.name
        let conquestedCount = dataSource.filter { $0.isConquested }.count
        let percent = Int(Float(conquestedCount) / Float(dataSource.count) * 100)
        self.completeLabel.text = "\(name)님\n \(percent)% 정복"
        
        for (index, place) in dataSource.enumerated() {
            if place.isConquested {
                pins[index].setBackgroundImage(#imageLiteral(resourceName: "selectStar"), for: .normal)
            }
        }
    }
    
}

extension MainViewController: UserInfoServiceDelegate {
    func userInfo(didUpdateUserInfo userInfo: UserInfo) {
        // update ui
        print("user info : \(userInfo)")
    }
}
