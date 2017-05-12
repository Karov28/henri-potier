//
//  HenriPotierTests.swift
//  HenriPotierTests
//
//  Created by Rémi Caroff on 03/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import XCTest
import RxTest
import RxSwift

@testable import HenriPotier

class HenriPotierTests: XCTestCase {
    
    var disposeBag: DisposeBag?
    var viewModel: BooksListViewModel?
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        
        let booksRepo = BooksListRepository(with: NetworkConfig(isTesting: true).libraryProvider)
        let offersRepo = OffersListRepository(with: NetworkConfig(isTesting: true).libraryProvider)
        self.viewModel = BooksListViewModel(with: booksRepo, offersRepository: offersRepo)
    }
    
    override func tearDown() {
        self.disposeBag = nil
        self.viewModel = nil
        super.tearDown()
    }
    
    func fetchBooks() {
        self.viewModel?.getBooks()
            .subscribe(onNext: { success in
                XCTAssertTrue(success)
            })
            .disposed(by: disposeBag!)
        
        self.viewModel?.input.refresh.onNext(true)
    }
    
    func testIfAllBooksAreFetched() {
        self.fetchBooks()
        self.viewModel?.output.displayedBooks.asObservable()
            .subscribe(onNext: { books in
                XCTAssert(books.count == 7)
            })
        .disposed(by: disposeBag!)
    }
    
    
    func testIfSelectedBooksIsEmptyOnLoad() {
        self.fetchBooks()
        XCTAssert(self.viewModel?.selectedBooks.value.count == 0)
    }
    
    
    func testIfSelectedBooksUpdatesOnGoodInput() {
        self.fetchBooks()
        self.viewModel?.input.bookSelected.onNext("c8fabf68-8374-48fe-a7ea-a00ccd07afff")
        self.viewModel?.output.selectedBooks.asObservable()
            .subscribe(onNext: { sections in
                XCTAssert(sections.count == 1)
                XCTAssert(sections.last!.items.count == 1)
            })
        .disposed(by: disposeBag!)
    }
    
    func testIfSelectedBooksDoesNotUpdateOnWrongInput() {
        self.fetchBooks()
        self.viewModel?.input.bookSelected.onNext("helloWorld")
        self.viewModel?.output.selectedBooks.asObservable()
            .subscribe(onNext: { sections in
                XCTAssert(sections.count == 0)
            })
        .disposed(by: disposeBag!)
    }
    
    func testSelectedBooksCountAfterInsertAndDelete() {
        self.fetchBooks()
        var sectionsCount = [Int]()
        var booksCount = [Int]()
        self.viewModel?.output.selectedBooks.asObservable()
            .subscribe(onNext: { sections in
                sectionsCount.append(sections.count)
                sections.forEach {
                    booksCount.append($0.items.count)
                }
            })
            .disposed(by: disposeBag!)
        
        self.viewModel?.input.bookSelected.onNext("c8fabf68-8374-48fe-a7ea-a00ccd07afff")
        self.viewModel?.input.bookSelected.onNext("c8fabf68-8374-48fe-a7ea-a00ccd07afff")
        
        XCTAssertEqual(sectionsCount, [0,1,1])
        XCTAssertEqual(booksCount, [1,2])
        
        self.viewModel?.input.bookDeleted.onNext(1) // In range index
        XCTAssertEqual(booksCount, [1,2,1])
        
        self.viewModel?.input.bookDeleted.onNext(1337) // Out of range index
        XCTAssertEqual(booksCount, [1,2,1])
    }
    
    
    
}
