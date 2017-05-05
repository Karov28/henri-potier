//
//  Offer.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 03/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit
import ObjectMapper

class OffersCollection: NSObject, Mappable {
    
    var offers: [Offer] = []
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        offers <- map["offers"]
    }
}


class Offer: NSObject, Mappable {
    
    var type: String!
    var value: Int!
    var sliceValue: Int?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        
        type <- map["type"]
        value <- map["value"]
        sliceValue <- map["sliceValue"]
        
    }
    
}
