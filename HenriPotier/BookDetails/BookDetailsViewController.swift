//
//  BookDetailsViewController.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 06/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit
import Sugar
import Kingfisher
import GSImageViewerController

protocol BookDetailsViewControllerDelegate {
    func didAddBookToCart(bookISBN: String)
}

class BookDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var dismissButton: UIButton!
    
    @IBOutlet var backgroundIV: UIImageView!
    @IBOutlet var coverIV: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var synopsisTitleLabel: UILabel!
    @IBOutlet var synopsisBodyLabel: UILabel!
    @IBOutlet var addToCartButton: UIButton!
    
    var selectedBook: BookVM!
    var delegate: BookDetailsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addToCartButton.imageView?.contentMode = .scaleAspectFit
        
        self.backgroundIV.kf.setImage(with: URL(string: selectedBook.cover), placeholder: UIImage(named: "placeholder"))
        self.coverIV.kf.setImage(with: URL(string: selectedBook.cover), placeholder: UIImage(named: "placeholder"))
        self.titleLabel.text = selectedBook.title
        self.priceLabel.text = selectedBook.price
        self.synopsisTitleLabel.text = "synopsis".localized
        self.synopsisBodyLabel.text = selectedBook.synopsis
        self.addToCartButton.setTitle("add_to_cart".localized, for: .normal)
        self.addToCartButton.layer.cornerRadius = self.addToCartButton.frame.size.height/2
        
    }

    @IBAction func addToCartButtonTapped() {
        self.delegate.didAddBookToCart(bookISBN: self.selectedBook.isbn)
        self.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 20 {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func close(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imageButtonTapped() {
        let imageInfo = GSImageInfo(image: self.coverIV.image!, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: self.coverIV)
        let viewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        present(viewer, animated: true, completion: nil)
    }


}
