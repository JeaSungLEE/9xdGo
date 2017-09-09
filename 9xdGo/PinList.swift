//
//  PinList.swift
//  9xdGo
//
//  Created by 이재성 on 09/09/2017.
//  Copyright © 2017 이재성. All rights reserved.
//

import UIKit

private let pinSize: CGFloat = 20
private let defaultMapWidth: CGFloat = 1674
private let defaultMapHeight: CGFloat = 1674

private let pinAxisList = [CGPoint(x: 100, y: 100),
                           CGPoint(x: 1674, y: 1674)]

class PinList {
    private var mapHeight: CGFloat?
    var pinList = [PinModel]()
    
    func itemAppend(point: CGPoint, image: UIImage, size: CGSize) -> PinModel {
        let newPoint = calculatorPinFrame(point: point)
        
        let item = PinModel(point: newPoint, image: image, size: size)
        
        return item
    }
    
    init(mapHeight: CGFloat) {
        self.mapHeight = mapHeight
        
        for axis in pinAxisList {
            let size = CGSize(width: pinSize, height: pinSize)
            let item = itemAppend(point: axis, image: #imageLiteral(resourceName: "redPin"), size: size)
            pinList.append(item)
        }
    }
    
    private func calculatorPinFrame(point: CGPoint) -> CGPoint {
        let newX = (point.x / defaultMapWidth) * getScreenSize().width
        let newY = (point.y / defaultMapHeight) * getScreenSize().width + calculatorImageTopInset()
        let newFrame = CGPoint(x: newX, y: newY)
        
        return newFrame
    }
    
    private func calculatorImageTopInset() -> CGFloat {
        guard let mapHeight = mapHeight else { return 0 }
        let topInset: CGFloat = mapHeight - (defaultMapHeight / (defaultMapWidth / getScreenSize().width))
        return topInset / 2
    }
}
