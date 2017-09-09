//
//  Product.swift
//  9xdGo
//
//  Created by 이규진 on 2017. 9. 9..
//  Copyright © 2017년 이재성. All rights reserved.
//

import Foundation

import SwiftyJSON

struct Product {
    let id: Int
    let name: String
    let imageURL: URL?
    let description: String
    let stock: Int
    let ordered: Int
    let price: Int
    let sale: Int
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.imageURL = URL(string: json["imageUrl"].stringValue)
        self.description = json["description"].stringValue
        self.stock = json["stock"].intValue
        self.ordered = json["ordered"].intValue
        self.price = json["price"].intValue
        self.sale = json["sale"].intValue
    }
    
}
