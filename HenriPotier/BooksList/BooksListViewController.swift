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

class BooksListViewController: UIViewController, UICollectionViewDelegateFlowLayout, BookDetailsViewControllerDelegate {
    
    var disposeBag = DisposeBag()
    
    let interactor = Interactor()
    
    @IBOutlet var collectionView: UICollectionView!
    var viewModel: BooksListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.setupOutput()
        self.setupInput()
        self.setupCollectionView()
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
    
    func setupCollectionView() {
        
        self.collectionView.rx.modelSelected(BookVM.self)
            .subscribe(onNext: { model in
                self.performSegue(withIdentifier: "showDetails", sender: model)
            })
        .disposed(by: disposeBag)
    }
    
    func didAddBookToCart(bookISBN: String) {
        
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let destVC = segue.destination as! BookDetailsViewController
            destVC.delegate = self
            destVC.selectedBook = sender as! BookVM
        }
    }
}


//extension BooksListViewController: UIViewControllerTransitioningDelegate {
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return DismissAnimator()
//    }
//    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return interactor.hasStarted ? interactor : nil
//    }
//}

