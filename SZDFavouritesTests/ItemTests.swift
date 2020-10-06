//
//  ItemTests.swift
//  SZDFavouritesTests
//
//  Created by Sandy House on 2020-10-06.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import XCTest
@testable import SZDFavourites

class ItemTests: XCTestCase {

    let testImage1 = UIImage(data: Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+L+2HgAE4AItDFmtVQAAAABJRU5ErkJggg==")!)
    let testImage2 = UIImage(data: Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==")!)
    
    var item1: Item!
    var item2: Item!
    
    override func setUp() {
        item1 = Item(name: "Item1")
        item2 = Item(name: "Item2", image: testImage1)
    }

    override func tearDown() {}
    
    func testInit() {
        // init name
        XCTAssert(item1.name == "Item1")
        
        // init with no image
        XCTAssertNil(item1.image)
        
        // init with image
        XCTAssertNotNil(item2.image)
        XCTAssert(item2.image == testImage1)
    }

    func testEditName() {
        // name -> new name
        item1.edit(name: "ItemA")
        XCTAssert(self.item1.name == "ItemA")
    }

    func testEditImage() {
        // no image -> image
        XCTAssertNil(item1.image)
        item1.edit(image: testImage1)
        XCTAssertNotNil(item1.image)
        XCTAssert(item1.image == testImage1)
        
        // image -> new image
        item1.edit(image: testImage2)
        XCTAssert(item1.image == testImage2)

        // image -> no image
        item1.edit(image: nil)
        XCTAssertNil(item1.image)
    }
    
    func testEquals() {
        XCTAssert(item1 != item2)
        XCTAssert(item1 == item1)
    }
    
    // TODO: testPersistence 
}
