//
//  StripeGatewayTests.swift
//  mammafoodie
//
//  Created by Akshit Zaveri on 17/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import XCTest
@testable import mammafoodie

class StripeGatewayTests: XCTestCase {
    
    var gateway: StripeGateway!
    
    override func setUp() {
        super.setUp()
        self.gateway = StripeGateway()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddPaymentMethod() {
        
    }
    
}
