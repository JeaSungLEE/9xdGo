//
//  MainViewController.swift
//  9xdGo
//
//  Created by 이재성 on 09/09/2017.
//  Copyright © 2017 이재성. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var mapImageView: UIImageView!
    private var index = 0
    private let profileViewHeight: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProfileImage()
        makePins()
    }
    
    private func setProfileImage() {
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
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
        print(sender.tag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
