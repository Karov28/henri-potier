//
//  ViewController.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 03/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    @IBOutlet var collectionView: UICollectionView!
    
    var viewModel: BooksListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func setupInput() {
        
    }
    
    func setupOutput() {
        
    
        
        
        
        self.viewModel.output.displayedBooks.asObservable()
        .bind(to: self.collectionView.rx.items(cellIdentifier: "", cellType: BooksListCollectionViewCell.self)) { index, model, cell in
                
        }
        .disposed(by: disposeBag)
        
        
    }
    
}

