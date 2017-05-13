//
//  OffersReductionsTests.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 13/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import XCTest
@testable import HenriPotier

class OffersReductionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPercentage() {
        let offer = Offer()
        offer.type = "percentage"
        offer.value = 10
        
        let reducFor100 = offer.getAbsoluteReductionFor(price: 100)
        XCTAssertEqual(reducFor100, 10)
    }
    
    func testSlice() {
        let offer = Offer()
        offer.value = 12
        offer.sliceValue = 100
        offer.type = "slice"
        
        let reducFor100 = offer.getAbsoluteReductionFor(price: 100)
        XCTAssertEqual(reducFor100, 12)
    }
    
    func testMinus() {
        let offer = Offer()
        offer.value = 15
        offer.type = "minus"
        
        let reducFor100 = offer.getAbsoluteReductionFor(price: 100)
        XCTAssertEqual(reducFor100, 15)
    }
}
