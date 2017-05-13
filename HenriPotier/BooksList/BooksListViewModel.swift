//
//  BooksListViewModel.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 05/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import Moya_ObjectMapper

protocol ViewModelError {
    var viewModelError: PublishSubject<APIError> { get set }
}

protocol BooksListViewModelInput {
    var refresh: PublishSubject<Bool> { get set }
    var validateTapped: PublishSubject<Bool> { get set }
    var bookSelected: PublishSubject<String> { get set }
    var bookDeleted: PublishSubject<Int> { get set }
}

protocol BooksListViewModelOutput {
    var displayedBooks: Variable<[BookVM]> { get set }
    var selectedBooks: Variable<[CartSection]> { get set }
    
    func getSubTotalPrice() -> Observable<(Int, String)>
    func getBestPrice() -> Observable<(Int, String)>
}

class BooksListViewModel: NSObject, BooksListViewModelInput, BooksListViewModelOutput, ViewModelError {
    var viewModelError: PublishSubject<APIError> = PublishSubject()
    var disposeBag = DisposeBag()
    
    public var output: BooksListViewModelOutput { return self }
    public var input: BooksListViewModelInput { return self }
    
    private var booksRepository: BooksListRepositoryProtocol
    private var offersRepository: OffersListRepositoryProtocol
    
    // input
    internal var refresh: PublishSubject<Bool> = PublishSubject()
    internal var validateTapped: PublishSubject<Bool> = PublishSubject()
    internal var bookSelected: PublishSubject<String> = PublishSubject()
    internal var bookDeleted: PublishSubject<Int> = PublishSubject()
    
    // output
    internal var displayedBooks: Variable<[BookVM]> = Variable([BookVM]())
    internal var selectedBooks: Variable<[CartSection]> = Variable([CartSection]())
    
    private var allBooks: [Book] = [Book]()
    
    init(with booksRepository: BooksListRepositoryProtocol, offersRepository: OffersListRepositoryProtocol) {
        self.booksRepository = booksRepository
        self.offersRepository = offersRepository
        
        super.init()
        
        self.bookSelected.asObservable()
            .subscribe(onNext: { bookISBN in
                if let selected = self.displayedBooks.value.filter({ b -> Bool in
                    return b.isbn == bookISBN
                }).last {
                    
                    var section = self.selectedBooks.value.last
                    if section == nil {
                        section = CartSection()
                    }
                    section!.items.append(selected)
                    self.selectedBooks.value = [section!]
                }
             
            })
        .disposed(by: disposeBag)
        
        
        self.bookDeleted.asObservable()
            .subscribe(onNext: { index in
                var section = self.selectedBooks.value.last!
                if 0...section.items.count-1 ~= index {
                    section.items.remove(at: index)
                    self.selectedBooks.value = [section]
                }
            })
        .disposed(by: disposeBag)
    }
    
    func getSelectedBooksCount() -> Int {
        
        if let section = self.selectedBooks.value.last {
            return section.items.count
        }
        
        return 0
    }
    
    func getBooks() -> Observable<Bool> {
        return self.refresh.flatMapLatest({ isRefreshing -> Observable<Bool> in
            return self.booksRepository.getBooks()
                .mapArray(Book.self)
                .map({ books -> Bool in
                    self.allBooks = books
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
    
    func getSelectedBooks() -> [Book] {
        let isbns = self.selectedBooks.value.last!.items.map({return $0.isbn})
        var b = [Book]()
        isbns.forEach { isbn in
            if allBooks.contains(where: { book -> Bool in
                book.isbn == isbn
            }){
                b.append(self.allBooks.filter({ return $0.isbn == isbn }).last!)
            }
        }
    
        return b
    }
    
    func getSubTotalPrice() -> Observable<(Int, String)> {
        return self.selectedBooks.asObservable()
        .flatMapLatest({ cartSection -> Observable<(Int, String)> in
            var total = 0
            self.getSelectedBooks().forEach {
                total += $0.price
            }
            return Observable.just((total, "\(total) "+"currency".localized))
        })
    }
    
    
    func getBestPrice() -> Observable<(Int, String)> {
        
        return self.getSubTotalPrice()
        .flatMapLatest({ (subtotal, formattedString) -> Observable<(Int, Offer?)> in
            if subtotal == 0 {
                return Observable.just((0, nil))
            }
            return self.getBestOffer(subTotal: subtotal)
        })
        .flatMapLatest({ (subTotal, offer) -> Observable<(Int, String)> in
            if offer == nil {
                return Observable.just((subTotal, "\(subTotal) "+"currency".localized))
            } else {
                var priceWithReduc = subTotal - offer!.getAbsoluteReductionFor(price: subTotal)
                if priceWithReduc < 0 {
                    priceWithReduc = 0
                }
                return Observable.just((priceWithReduc, "\(priceWithReduc) "+"currency".localized))
            }
        })
    }
    
    func getBestOffer(subTotal: Int) -> Observable<(Int, Offer?)> {
        return self.getOffers()
        .flatMapLatest({ collection -> Observable<(Int, Offer?)> in
            var bestOffer: Offer?
            collection.offers.forEach({ offer in
                if bestOffer == nil {
                    bestOffer = offer
                } else {
                    if bestOffer!.getAbsoluteReductionFor(price: subTotal) < offer.getAbsoluteReductionFor(price: subTotal) {
                        bestOffer = offer
                    }
                }
            })
            
            return Observable.just((subTotal, bestOffer))
        })
    }
    
    func getOffers() -> Observable<OffersCollection> {
        if let section = self.selectedBooks.value.last {
            let isbns = section.items.map({return $0.isbn})
            return self.offersRepository.getOffers(books: isbns as! [String])
                .map({ response -> Response in
                    if response.statusCode == 404 {
                        let json = ["offers":[]]
                        let data = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions(rawValue: 0))
                        return Response(statusCode: response.statusCode, data: data)
                    }
                    
                    return response
                })
                .mapObject(OffersCollection.self)
                .do(onError: { error in
                    print("error getting offers : \(error.localizedDescription)")
                })
        } else {
            let coll = OffersCollection()
            coll.offers = []
            return Observable.just(coll)
        }
        
    }
    

}
