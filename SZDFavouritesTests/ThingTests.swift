//
//  ThingTests.swift
//  SZDFavouritesTests
//
//  Created by Sandy House on 2020-10-06.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import XCTest
@testable import SZDFavourites

class ThingTests: XCTestCase {

    var thing1: Thing!
    var thing2: Thing!
    
    override func setUp() {
        let items1 = [Item(name: "Item1"), Item(name: "Item2"), Item(name: "Item3")]
        // [1,2,3]
        thing1 = Thing(name: "Thing1", items: items1)
        let items2 = [Item(name: "Item1"), Item(name: "Item2"), Item(name: "Item3")]
        // [1,2,3]
        thing2 = Thing(name: "Thing2", items: items2)
    }

    override func tearDown() {}

    func testInit() {
        // name, no items
        let thing1 = Thing(name: "Thing1")
        XCTAssert(thing1.name == "Thing1")
        XCTAssert(thing1.items.isEmpty)
        
        // name, items
        let thing2 = Thing(name: "Thing2", items: [Item(name: "Item1"), Item(name: "Item2")])
        XCTAssert(thing2.name == "Thing2")
        XCTAssert(thing2.items.count == 2)
    }
    
    func testEdit() {
        XCTAssert(thing1.name == "Thing1")
        thing1.edit(name: "ThingA")
        XCTAssert(thing1.name == "ThingA")
    }

    func testItems() {
        // count: [1, 2, 3]
        XCTAssert(thing1.itemCount() == 3)
        
        // item at
        XCTAssert(thing1.item(at: 0).name == "Item1")
        XCTAssert(thing1.item(at: 1).name == "Item2")
        XCTAssert(thing1.item(at: 2).name == "Item3")
        
        // indexOfItem
        XCTAssert(thing1.indexOfItem(with: "Item3") == 2)
        XCTAssert(thing1.indexOfItem(with: "ItemA") == nil)
        
        // exists
        XCTAssert(thing1.exists(item: "Item1"))
        XCTAssert(!thing1.exists(item: "ItemA"))
        
        // add item: [1, 2, 3, 4]
        thing1.addItem(name: "Item4")
        XCTAssert(thing1.itemCount() == 4)
        XCTAssert(thing1.item(at: 3).name == "Item4")
        
        // add item exists: [1, 2, 3, 4]
        thing1.addItem(name: "Item1")
        XCTAssert(thing1.itemCount() == 4)
        XCTAssert(thing1.item(at: 0).name == "Item1")
        
        // insert item: [1, 1.5, 2, 3, 4]
        thing1.insert(item: Item(name: "Item1.5"), at: 1)
        XCTAssert(thing1.itemCount() == 5)
        XCTAssert(thing1.item(at: 1).name == "Item1.5")
        
        // remove item: [1, 2, 3, 4]
        let item = thing1.removeItem(at: 1)
        XCTAssert(item.name == "Item1.5")
        XCTAssert(thing1.itemCount() == 4)
        XCTAssert(thing1.indexOfItem(with: "Item1.5") == nil)
        
        // move item
        // [1, 4, 3, 2]
        thing1.move(item: 3, to: 1)
        XCTAssert(thing1.item(at: 1).name == "Item4")
        // [4, 3, 2, 1]
        thing1.move(item: 0, to: 3)
        XCTAssert(thing1.item(at: 3).name == "Item1")
    }
    
    func testEditItems() {
        // name [1,B,3]
        thing1.edit(item: 1, with: "ItemB")
        XCTAssert(thing1.item(at: 1).name == "ItemB")
        
        // existing name
        thing1.edit(item: 0, with: "ItemB")
        XCTAssert(thing1.item(at: 0).name == "Item1")
        XCTAssert(thing1.item(at: 1).name == "ItemB")
        
        // image
        let image = UIImage()
        thing1.edit(item: 2, with: image)
        XCTAssert(thing1.item(at: 2).image == image)
    }
    
    func testEquals() {
        XCTAssert(thing1 == thing1)
        XCTAssert(thing1 != thing2)
    }
}
