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

class BooksListViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    var disposeBag = DisposeBag()
    
    @IBOutlet var collectionView: UICollectionView!
    var viewModel: BooksListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.setupOutput()
        self.setupInput()
        self.viewModel.input.refresh.onNext(true)
    }

    func setupInput() {
        self.viewModel.getBooks()
        .subscribe(onNext: { success in
            
        })
        .disposed(by: disposeBag)
    }
    
    func setupOutput() {
        
        self.viewModel.output.displayedBooks.asObservable()
        .bind(to: self.collectionView.rx.items(cellIdentifier: "bookCell", cellType: BooksListCollectionViewCell.self)) { index, model, cell in
            cell.setContentWith(book: model)
        }
        .disposed(by: disposeBag)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width/2-10, height: (self.view.frame.size.width/2)*1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
}

