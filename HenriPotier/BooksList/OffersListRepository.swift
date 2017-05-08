//
//  OffersListRepository.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 05/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit
import Moya
import RxSwift

protocol OffersListRepositoryProtocol {
    func getOffers(books: [String]) -> Observable<Response>
}

class OffersListRepository: NSObject, OffersListRepositoryProtocol {
    var provider: RxMoyaProvider<LibraryAPI>
    
    init(with provider: RxMoyaProvider<LibraryAPI>) {
        self.provider = provider
    }
    
    func getOffers(books: [String]) -> Observable<Response> {
        
        return self.provider.request(.getOffers(isbns: books))
        .filterSuccessfulStatusAndRedirectCodes()
        .observeOn(MainScheduler.instance)
        .debug()
        
    }
}
