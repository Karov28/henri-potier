//
//  LibraryAPI.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 03/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit
import Moya



struct NetworkConfig {
    
    var isTesting = false
    
    var libraryProvider: RxMoyaProvider<LibraryAPI> {
        if self.isTesting {
            return RxMoyaProvider<LibraryAPI>(stubClosure:MoyaProvider.immediatelyStub)
        }
        return RxMoyaProvider<LibraryAPI>()
    }
    
}


public enum LibraryAPI {
    case getBooks
    case getOffers(isbns:[String])
}


extension LibraryAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: "http://henri-potier.xebia.fr")!
    }
    
    public var path: String {
        switch self {
        case .getBooks:
            return "/books"
        case .getOffers(let isbns):
            var str = "/"
            for (idx, isbn) in isbns.enumerated() {
                str.append(isbn)
                str.append(idx == isbns.count-1 ? "/commercialOffers" : ",")
            }
            return str
        }
    }
    
    public var parameterEncoding: Moya.ParameterEncoding {
        return URLEncoding.default
    }
    
    
    public var parameters: [String : Any]? {
        return nil
    }
    
    
    public var task: Task {
        return .request
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    
    public var sampleData: Data {
        
        switch self {
        case .getBooks:
            return self.getDataFrom(jsonFile: "Books_200")
        case .getOffers:
            return self.getDataFrom(jsonFile: "Offers_200")
        }
        
    }
    
    private func getDataFrom(jsonFile: String) -> Data {
        if let stubURL = Bundle.main.url(forResource: jsonFile, withExtension: "json") {
            do {
                return try Data(contentsOf: stubURL)
            } catch (let error) {
                print("error parsing \(jsonFile).json : \(error.localizedDescription)")
            }
        }
        
        return Data()
    }
}
