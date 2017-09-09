//
//  Place.swift
//  9xdGo
//
//  Created by 이규진 on 2017. 9. 9..
//  Copyright © 2017년 이재성. All rights reserved.
//

import Foundation

import SwiftyJSON

struct Place {
    let id: Int
    let name: String
    let description: String
    let address: String
    let latitude: Double
    let longitude: Double
    let radius: Double
    let products: [Product]
    let isConquested: Bool
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.description = json["description"].stringValue
        self.address = json["address"].stringValue
        self.latitude = json["latitude"].doubleValue
        self.longitude = json["latitude"].doubleValue
        self.radius = json["radius"].doubleValue
        self.products = json["products"].arrayValue.map { Product(json: $0) }
        self.isConquested = json["conquest"].bool ?? false
    }
    
}
