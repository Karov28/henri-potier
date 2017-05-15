//
//  Book.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 03/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit
import ObjectMapper

class Book: NSObject, Mappable {
    
    var isbn: String!
    var title: String!
    var price: Int!
    var cover: String!
    var synopsis: [String] = []
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        isbn <- map["isbn"]
        title <- map["title"]
        price <- map["price"]
        cover <- map["cover"]
        synopsis <- map["synopsis"]
    }
    
}
