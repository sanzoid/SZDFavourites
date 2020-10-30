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
        // [1,2,3]
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
        XCTAssert(thingMap2.thing(with: "Thing1")?.name == "Thing1")
    }
    
    func testMap() {
        // count
        XCTAssert(thingMap.count == 3)
        
        // thing with
        XCTAssert(thingMap.thing(with: "Thing2")!.name == "Thing2")
        // case sensitive
        XCTAssert(thingMap.thing(with: "THING2") == nil)
        // case insensitive
        XCTAssert(thingMap.thing(with: "THING2", caseSensitive: false)!.name == "Thing2")
        
        // exists
        XCTAssert(thingMap.exists(name: "Thing1"))
        XCTAssert(!thingMap.exists(name: "Thing4"))
        // case sensitive
        XCTAssert(!thingMap.exists(name: "THING1"))
        // case insensitive
        XCTAssert(thingMap.exists(name: "THING1", caseSensitive: false))
    }
    
    func testAdd() {
        // by name: [1, 2, 3, 4]
        thingMap.add(thing: "Thing4")
        XCTAssert(thingMap.count == 4)
        XCTAssert(thingMap.exists(name: "Thing4"))
        
        // exists: [1, 2, 3, 4]
        thingMap.add(thing: "Thing4")
        XCTAssert(thingMap.count == 4)
        
        // exists in different case: [1, 2, 3, 4, 1]
        thingMap.add(thing: "THING1")
        XCTAssert(thingMap.count == 5)
        XCTAssert(thingMap.exists(name: "THING1"))
    }
    
    func testRemove() {
        // by thing [1, 3]
        let thing2 = thingMap.remove(thing: things["Thing2"]!)
        XCTAssert(thingMap.count == 2)
        XCTAssert(thingMap.thing(with: "Thing2") == nil)
        XCTAssert(thing2?.name == "Thing2")

        // by name [1]
        let thing3 = thingMap.remove(thing: "Thing3")
        XCTAssert(thingMap.count == 1)
        XCTAssert(thingMap.thing(with: "Thing3") == nil)
        XCTAssert(thing3?.name == "Thing3")

        // non-existent
        XCTAssert(thingMap.thing(with: "Thing0") == nil)
        let thing0 = thingMap.remove(thing: "Thing0")
        XCTAssert(thingMap.count == 1)
        XCTAssert(thing0 == nil)

        // non-existent, exists in different case
        XCTAssert(!thingMap.exists(name: "THING1", caseSensitive: true))
        XCTAssert(thingMap.exists(name: "THING1", caseSensitive: false))
        let thing1 = thingMap.remove(thing: "THING1")
        XCTAssert(thingMap.count == 1)
        XCTAssert(thing1 == nil)

        // empty []
        thingMap.remove(thing: "Thing1")
        XCTAssert(thingMap.count == 0)
    }

    func testEditThing() {
        // [1,B,3]
        thingMap.edit(thing: "Thing2", with: "ThingB")
        XCTAssert(thingMap.count == 3)
        XCTAssert(!thingMap.exists(name: "Thing2"))
        XCTAssert(thingMap.thing(with: "ThingB")?.name == "ThingB")

        // doesn't exist - no change
        thingMap.edit(thing: "ThingX", with: "Thing4")
        XCTAssert(!thingMap.exists(name: "ThingX"))
        XCTAssert(!thingMap.exists(name: "Thing4"))

        // new exists - no change
        XCTAssert(thingMap.exists(name: "Thing1"))
        XCTAssert(thingMap.exists(name: "ThingB"))
        thingMap.edit(thing: "Thing1", with: "ThingB")
        XCTAssert(thingMap.exists(name: "Thing1"))
        XCTAssert(thingMap.exists(name: "ThingB"))
        XCTAssert(thingMap.thing(with: "Thing1")?.name == "Thing1")

        // new is same in different case
        XCTAssert(thingMap.exists(name: "Thing1"))
        thingMap.edit(thing: "Thing1", with: "THING1")
        XCTAssert(!thingMap.exists(name: "Thing1"))
        XCTAssert(thingMap.exists(name: "THING1"))
        
        // new exists in different case
        XCTAssert(thingMap.exists(name: "Thing3"))
        XCTAssert(thingMap.exists(name: "ThingB"))
        thingMap.edit(thing: "Thing3", with: "THINGB")
        XCTAssert(!thingMap.exists(name: "Thing3"))
        XCTAssert(thingMap.exists(name: "THINGB"))
        XCTAssert(thingMap.exists(name: "ThingB"))
    }
}
