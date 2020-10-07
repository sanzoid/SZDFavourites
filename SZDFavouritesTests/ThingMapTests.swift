//
//  ThingMapTests.swift
//  SZDFavouritesTests
//
//  Created by Sandy House on 2020-10-07.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import XCTest
@testable import SZDFavourites

class ThingMapTests: XCTestCase {

    let things = ["Thing1": Thing(name: "Thing1"), "Thing2": Thing(name: "Thing2"), "Thing3": Thing(name: "Thing3")]
    var thingMap: ThingMap!
    
    override func setUp() {
        thingMap = ThingMap(things: things)
    }

    override func tearDown() {}

    func testInit() {
        // no things
        let thingMap1 = ThingMap()
        XCTAssert(thingMap1.count == 0)
        
        // things
        let thingMap2 = ThingMap(things: ["Thing1": Thing(name: "Thing1")])
        XCTAssert(thingMap2.count == 1)
        XCTAssert(thingMap2["Thing1"]?.name == "Thing1")
    }
    
    func testMap() {
        // count
        XCTAssert(thingMap.count == 3)
        
        // subscript
        XCTAssert(thingMap["Thing2"]?.name == "Thing2")
        
        // remove
        // by thing [1, 3]
        let thing2 = thingMap.remove(thing: things["Thing2"]!)
        XCTAssert(thingMap.count == 2)
        XCTAssert(thingMap["Thing2"] == nil)
        XCTAssert(thing2?.name == "Thing2")
        // by name [1]
        let thing3 = thingMap.remove(thing: "Thing3")
        XCTAssert(thingMap.count == 1)
        XCTAssert(thingMap["Thing3"] == nil)
        XCTAssert(thing3?.name == "Thing3")
        // non-existent
        XCTAssert(thingMap["Thing0"] == nil)
        let thing0 = thingMap.remove(thing: "Thing0")
        XCTAssert(thingMap.count == 1)
        XCTAssert(thing0 == nil)
        // empty []
        thingMap.remove(thing: "Thing1")
        XCTAssert(thingMap.count == 0)
        
        // add
        // by name [1]
        thingMap.add(thing: "Thing1")
        XCTAssert(thingMap.count == 1)
        XCTAssert(thingMap["Thing1"]?.name == "Thing1")
        // by thing [1, 2]
        thingMap.add(thing: Thing(name: "Thing2"))
        XCTAssert(thingMap.count == 2)
        XCTAssert(thingMap["Thing2"]?.name == "Thing2")
    }
    
    func testEditThing() {
        thingMap.edit(thing: "Thing2", with: "ThingB")
        XCTAssert(thingMap.count == 3)
        XCTAssert(thingMap["Thing2"] == nil)
        XCTAssert(thingMap["ThingB"]?.name == "ThingB")
    }
}
