//
//  Calculator.swift
//  9xdGo
//
//  Created by 이규진 on 2017. 9. 10..
//  Copyright © 2017년 이재성. All rights reserved.
//

import Foundation

import Foundation
import CoreLocation

class Calculator {
    func distance(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
        let coordinate1 = CLLocation(latitude: lat1, longitude: lng1)
        let coordinate2 = CLLocation(latitude: lat2, longitude: lng2)
        
        let distanceInMeters = coordinate1.distance(from: coordinate2)
        let distanceInKilometers = (distanceInMeters / 1000)
        
        return distanceInKilometers
    }
    
}
