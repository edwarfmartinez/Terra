//
//  TerraTests.swift
//  TerraTests
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 30/05/22.
//

import XCTest
@testable import Terra

class TerraTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    var terraManager = TerraManager()
    private var terraExpectation: XCTestExpectation!
    private var resultsFieldsModel = FieldsModel()
    private var resultsFieldDetailModel = FieldDetailModel()
    
    func testNumFields(){
        
        terraExpectation = expectation(description: "Terra")
        terraManager.delegate = self
        terraManager.getSecrets()
        terraManager.fetchFields()
        
        waitForExpectations(timeout: 10)
        XCTAssertEqual(self.resultsFieldsModel.mdlName?.count, 10)
        
    }
    
    
    func testSatImage(){
        
        terraExpectation = expectation(description: "TerraFieldDetail")
        
        terraManager.delegateImages = self
        terraManager.getSecrets()
        terraManager.fetchFieldDetail(polygonId: "6297d3faf03cc7d28771da16")
        waitForExpectations(timeout: 10)
        XCTAssertNotNil(self.resultsFieldDetailModel.mdlUrl)
        
    }
    
    func testLoadFieldsQuickly()  {
        measure {
            var terraManager = TerraManager()
            terraManager.delegate = self
            terraManager.getSecrets()
            terraManager.fetchFields()
        }
    }
}

extension TerraTests: TerraManagerDelegate{

    func didUpdateFields(_ terraManager: TerraManager, fields: FieldsModel) {
        resultsFieldsModel = fields
        terraExpectation.fulfill()
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}


extension TerraTests : SatelliteImagesDelegate{
    func didUpdateFieldDetail(_ terraManager: TerraManager, fields: FieldDetailModel) {
        resultsFieldDetailModel = fields
        terraExpectation.fulfill()
    }
}
