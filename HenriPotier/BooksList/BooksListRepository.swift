//
//  BooksListRepository.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 05/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit
import RxSwift
import Moya

protocol BooksListRepositoryProtocol {
    func getBooks() -> Observable<Response>
}

class BooksListRepository: NSObject, BooksListRepositoryProtocol {
    
    var provider: RxMoyaProvider<LibraryAPI>
    
    init(with provider: RxMoyaProvider<LibraryAPI>) {
        self.provider = provider
    }
    
    func getBooks() -> Observable<Response> {
        
        return self.provider.request(.getBooks)
        .filterSuccessfulStatusAndRedirectCodes()
        .observeOn(MainScheduler.instance)
        .debug()
        
    }

}
