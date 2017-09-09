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
        let pinList = PinList.init()
        
        for pinItem in pinList.pinList {
            setPin(pinItem: pinItem)
        }
    }
    
    private func setPin(pinItem: PinModel) {
        let pin = UIImageView(image: pinItem.image)
        pin.frame = CGRect(origin: .zero, size: pinItem.size)
        
        let newPointX = pinItem.point.x
        let newPointY = pinItem.point.y
        let newPoint = CGPoint(x: newPointX, y: newPointY)
        
        pin.center = newPoint
        
        self.mapImageView.addSubview(pin)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
