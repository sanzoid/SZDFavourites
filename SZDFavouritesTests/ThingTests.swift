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
        
        // different case 
        thing1.edit(name: "THINGA")
        XCTAssert(thing1.name == "THINGA")
    }

    func testItem() {
        // count: [1, 2, 3]
        XCTAssert(thing1.itemCount() == 3)
        
        // item at
        XCTAssert(thing1.item(at: 0).name == "Item1")
        XCTAssert(thing1.item(at: 1).name == "Item2")
        XCTAssert(thing1.item(at: 2).name == "Item3")
        
        // indexOfItem
        XCTAssert(thing1.indexOfItem(with: "Item3") == 2)
        XCTAssert(thing1.indexOfItem(with: "ItemA") == nil)
        // case sensitivite
        XCTAssert(thing1.indexOfItem(with: "iTem3") == nil)
        // case insensitive
        XCTAssert(thing1.indexOfItem(with: "iTem3", caseSensitive: false) == 2)
        
        // exists
        XCTAssert(thing1.exists(item: "Item1"))
        XCTAssert(!thing1.exists(item: "ItemA"))
        // case sensitive
        XCTAssert(!thing1.exists(item: "ITem1"))
        // case insensitive
        XCTAssert(thing1.exists(item: "ITem1", caseSensitive: false))
    }
    
    func testAddItem() {
        // [1, 2, 3, 4]
        thing1.addItem(name: "Item4")
        XCTAssert(thing1.itemCount() == 4)
        XCTAssert(thing1.item(at: 3).name == "Item4")
        
        // exists: [1, 2, 3, 4]
        thing1.addItem(name: "Item1")
        XCTAssert(thing1.itemCount() == 4)
        XCTAssert(thing1.item(at: 0).name == "Item1")
        
        // exists in different case: [1, 2, 3, 4, 1]
        thing1.addItem(name: "ITEM1")
        XCTAssert(thing1.itemCount() == 5)
        XCTAssert(thing1.exists(item: "ITEM1"))
    }
    
    func testInsertItem() {
        // [1, 1.5, 2, 3]
        thing1.insert(item: Item(name: "Item1.5"), at: 1)
        XCTAssert(thing1.itemCount() == 4)
        XCTAssert(thing1.item(at: 1).name == "Item1.5")
        
        // exists: [1, 1.5, 2, 3]
        thing1.insert(item: Item(name: "Item1.5"), at: 1)
        XCTAssert(thing1.itemCount() == 4)
        
        // exists in different case: [1, 1, 1.5, 2, 3]
        thing1.insert(item: Item(name: "ITEM1"), at: 1)
        XCTAssert(thing1.item(at: 1).name == "ITEM1")
    }
    
    func testRemoveItem() {
        // [1, 3]
        let item = thing1.removeItem(at: 1)
        XCTAssert(item.name == "Item2")
        XCTAssert(thing1.itemCount() == 2)
        XCTAssert(!thing1.exists(item: "Item2"))
    }
    
    func testMoveItem() {
        // [1, 3, 2]
        thing1.move(item: 2, to: 1)
        XCTAssert(thing1.item(at: 1).name == "Item3")
        XCTAssert(thing1.item(at: 2).name == "Item2")
        // [3, 2, 1]
        thing1.move(item: 0, to: 2)
        XCTAssert(thing1.item(at: 2).name == "Item1")
    }
    
    func testEditItem() {
        // name [1,B,3]
        thing1.edit(item: 1, with: "ItemB")
        XCTAssert(thing1.item(at: 1).name == "ItemB")
        
        // name exists
        thing1.edit(item: 0, with: "ItemB")
        XCTAssert(thing1.item(at: 0).name == "Item1")
        XCTAssert(thing1.item(at: 1).name == "ItemB")
        
        // name same in different case
        thing1.edit(item: 1, with: "ITEMB")
        XCTAssert(thing1.item(at: 1).name == "ITEMB")
        
        // name exists in different case
        thing1.edit(item: 0, with: "iTEMB")
        XCTAssert(thing1.item(at: 0).name == "iTEMB")
        
        // image
        let image = UIImage()
        thing1.edit(item: 2, with: image)
        XCTAssert(thing1.item(at: 2).image == image)
    }
    
    func testEquals() {
        XCTAssert(thing1 == thing1)
        XCTAssert(thing1 != thing2)
        
        // different case
        let THING1 = Thing(name: thing1.name.uppercased())
        XCTAssert(thing1 != THING1)
    }
}
