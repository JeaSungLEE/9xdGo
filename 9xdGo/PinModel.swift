//
//  PinModel.swift
//  9xdGo
//
//  Created by 이재성 on 09/09/2017.
//  Copyright © 2017 이재성. All rights reserved.
//

import UIKit

class PinModel: NSObject {
    let point: CGPoint
    let image: UIImage
    let size: CGSize
    
    init(point: CGPoint, image: UIImage, size: CGSize) {
        self.point = point
        self.image = image
        self.size = size
        
        super.init()
    }
}
