//
//  CartItemTableViewCell.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 07/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit
import Kingfisher

class CartItemTableViewCell: UITableViewCell {
    
    @IBOutlet var coverIV: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!

    
    func setContentWith(book: BookVM) {
        self.coverIV.kf.setImage(with: URL(string: book.cover), placeholder: UIImage(named: "placeholder"))
        self.titleLabel.text = book.title
        self.priceLabel.text = book.price
    }

}
