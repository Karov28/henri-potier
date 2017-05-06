//
//  BooksListCollectionViewCell.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 06/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit
import Kingfisher
import Sugar

class BooksListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var backgroundIV: UIImageView!
    func setContentWith(book: BookVM) {
        
        self.titleLabel.text = book.title
        self.priceLabel.text = book.price
        
        
        self.coverImageView.kf.setImage(with: URL(string: book.cover), placeholder: UIImage(named: "placeholder"))
        self.backgroundIV.kf.setImage(with: URL(string: book.cover), placeholder: UIImage(named: "placeholder"))
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds = true
    }
}
