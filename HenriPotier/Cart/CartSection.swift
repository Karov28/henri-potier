//
//  CartSection.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 08/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit
import RxDataSources

struct CartSection {
    var title = ""
    var items = [BookVM]()
}

extension CartSection: SectionModelType {
    
    init(original: CartSection, items: [BookVM]) {
        self = original
        self.items = items
    }

}
