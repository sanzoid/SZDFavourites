//
//  GroupTests.swift
//  SZDFavouritesTests
//
//  Created by Sandy House on 2020-10-06.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import XCTest
@testable import SZDFavourites

class GroupTests: XCTestCase {

    var group: Group!
    
    override func setUp() {
        let things = ["Thing1", "Thing2", "Thing3"]
        group = Group(name: "Group1", things: things)
    }

    override func tearDown() {}
    
    func testInit() {
        // name, no things
        let group1 = Group(name: "Group1")
        XCTAssert(group1.name == "Group1")
        XCTAssert(group1.things.isEmpty)
        
        // name, things
        let group2 = Group(name: "Group2", things: ["Thing1", "Thing2"])
        XCTAssert(group2.name == "Group2")
        XCTAssert(group2.things.count == 2)
    }
    
    func testEdit() {
        XCTAssert(group.name == "Group1")
        group.edit(name: "GroupA")
        XCTAssert(group.name == "GroupA")
    }
    
    func testEquals() {
        let group2 = Group(name: "Group2")
        XCTAssert(group == group)
        XCTAssert(group != group2)
    }
    
    func testThings() {
        // count
        XCTAssert(group.thingCount == 3)
        
        // thing at
        XCTAssert(group.thing(at: 0) == "Thing1")
        XCTAssert(group.thing(at: 1) == "Thing2")
        XCTAssert(group.thing(at: 2) == "Thing3")
        
        // indexOf
        XCTAssert(group.indexOf(thing: "Thing2") == 1)
        XCTAssert(group.indexOf(thing: "ThingA") == nil)
        
        // remove
        // [1, 2] index
        let thing3 = group.remove(thing: 2)!
        XCTAssert(thing3 == "Thing3")
        XCTAssert(group.thingCount == 2)
        XCTAssert(group.indexOf(thing: "Thing3") == nil)
        // [1] name
        let thing2 = group.remove(thing: "Thing2")!
        XCTAssert(thing2 == "Thing2")
        XCTAssert(group.thingCount == 1)
        XCTAssert(group.indexOf(thing: "Thing2") == nil)
        // [] to empty
        let thing1 = group.remove(thing: 0)!
        XCTAssert(thing1 == "Thing1")
        XCTAssert(group.thingCount == 0)
        XCTAssert(group.indexOf(thing: "Thing1") == nil)
        // non existent
        let thing0 = group.remove(thing: "Thing0")
        XCTAssert(thing0 == nil)
        
        // add
        // [1] add
        group.add(thing: "Thing1")
        XCTAssert(group.thingCount == 1)
        XCTAssert(group.thing(at: 0) == "Thing1")
        // [1, 2, 3] add multiple
        group.add(things: ["Thing2", "Thing3"])
        XCTAssert(group.thingCount == 3)
        XCTAssert(group.thing(at: 1) == "Thing2")
        XCTAssert(group.thing(at: 2) == "Thing3")
        // [1, 4, 2, 3]
        group.insert(thing: "Thing4", at: 1)
        XCTAssert(group.thingCount == 4)
        XCTAssert(group.thing(at: 1) == "Thing4")
    }
    
    func testEditThing() {
        group.edit(thing: 1, with: "ThingB")
        XCTAssert(group.thing(at: 1) == "ThingB")
    }
}
