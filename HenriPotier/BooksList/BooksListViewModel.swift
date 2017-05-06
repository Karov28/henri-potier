//
//  BooksListViewModel.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 05/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit
import RxSwift
import Moya_ObjectMapper

protocol BooksListViewModelInput {
    var refresh: PublishSubject<Bool> { get set }
    var validateTapped: PublishSubject<Bool> { get set }
}

protocol BooksListViewModelOutput {
    var displayedBooks: Variable<[BookVM]> { get set }
}

class BooksListViewModel: NSObject, BooksListViewModelInput, BooksListViewModelOutput {
    
    var disposeBag = DisposeBag()
    
    public var output: BooksListViewModelOutput { return self }
    public var input: BooksListViewModelInput { return self }
    
    var booksRepository: BooksListRepositoryProtocol
    var offersRepository: OffersListRepositoryProtocol
    
    // input
    var refresh: PublishSubject<Bool> = PublishSubject()
    var validateTapped: PublishSubject<Bool> = PublishSubject()
    
    // output
    var displayedBooks: Variable<[BookVM]> = Variable([BookVM]())
    
    init(with booksRepository: BooksListRepositoryProtocol, offersRepository: OffersListRepositoryProtocol) {
        self.booksRepository = booksRepository
        self.offersRepository = offersRepository
    }
    
    func getBooks() -> Observable<Bool> {
        return self.refresh.flatMapLatest({ isRefreshing -> Observable<Bool> in
            return self.booksRepository.getBooks()
                .mapArray(Book.self)
                .map({ books -> Bool in
                    self.displayedBooks.value = books.map({ book -> BookVM in
                        return BookVM(with: book)
                    })
                    
                    return true
                })
                
                .do(onError: { error in
                    self.displayedBooks.value = []
                })
        })
        
        
    }
    
    

}
