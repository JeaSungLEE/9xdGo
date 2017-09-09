//
//  PinList.swift
//  9xdGo
//
//  Created by 이재성 on 09/09/2017.
//  Copyright © 2017 이재성. All rights reserved.
//

import UIKit

private let pinSize: CGFloat = 30
private let defaultMapWidth: CGFloat = 1674
private let defaultMapHeight: CGFloat = 1674

private let pinAxisList = [CGPoint(x: 600, y: 600),
                           CGPoint(x: 1000, y: 1000)]

class PinList {
    var pinList = [PinModel]()
    
    func itemAppend(point: CGPoint, image: UIImage, size: CGSize) -> PinModel {
        let newPoint = calculatorPinFrame(point: point)
        
        let item = PinModel(point: newPoint, image: image, size: size)
        
        return item
    }
    
    init() {
        for axis in pinAxisList {
            let size = CGSize(width: pinSize, height: pinSize)
            let item = itemAppend(point: axis, image: #imageLiteral(resourceName: "redPin"), size: size)
            pinList.append(item)
        }
    }
    
    private func calculatorPinFrame(point: CGPoint) -> CGPoint {
        let newX = (point.x / defaultMapWidth) * getScreenSize().width
        let newY = (point.y / defaultMapHeight) * getScreenSize().height
        let newFrame = CGPoint(x: newX, y: newY)
        
        return newFrame
    }
}
