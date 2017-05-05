//
//  BookVM.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 05/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit

class BookVM: NSObject {
    
    var isbn: String
    var title: String
    var cover: String
    var isSelected: Bool = false
    
    
    init(with book: Book) {
        
        self.title = book.title
        self.cover = book.cover
        self.isbn = book.isbn
        
    }

}
