//
//  BookVM.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 05/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit
import Sugar
class BookVM: NSObject {
    
    var isbn: String!
    var title: String!
    var cover: String!
    var price: String!
    var synopsis: String!
    
    override init() {}
    
    init(with book: Book) {
        
        self.title = book.title
        self.cover = book.cover
        self.isbn = book.isbn
        self.price = "\(book.price!) " + "currency".localized
        
        var full = ""
        book.synopsis.forEach { part in
            full.append(part)
            full.append("\n\n")
        }
        
        self.synopsis = full
        
    }

}
