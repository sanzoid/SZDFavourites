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
        
        // case sensitive
        let GROUP = Group(name: group.name.uppercased())
        XCTAssert(group != GROUP)
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
        // case sensitive
        XCTAssert(group.indexOf(thing: "THING2") == nil)
        // case insensitive
        XCTAssert(group.indexOf(thing: "THING2", caseSensitive: false) == 1)
    }
    
    func testAddThing() {
        // add: [1, 2, 3, 4]
        group.add(thing: "Thing4")
        XCTAssert(group.thingCount == 4)
        XCTAssert(group.thing(at: 3) == "Thing4")
        
        // add multiple: [1, 2, 3, 4, 5, 6]
        group.add(things: ["Thing5", "Thing6"])
        XCTAssert(group.thingCount == 6)
        XCTAssert(group.thing(at: 4) == "Thing5")
        XCTAssert(group.thing(at: 5) == "Thing6")
        
        // insert: [1, 1.5, 2, 3, 4, 5, 6]
        group.insert(thing: "Thing1.5", at: 1)
        XCTAssert(group.thingCount == 7)
        XCTAssert(group.thing(at: 1) == "Thing1.5")
        
        // add exists - no change: [1, 1.5, 2, 3, 4, 5, 6]
        group.add(thing: "Thing1.5")
        XCTAssert(group.thingCount == 7)
        
        // insert exists - no change
        group.insert(thing: "Thing1.5", at: 1)
        XCTAssert(group.thingCount == 7)
        
        // add multiple exists - some change: [1, 1.5, 2, 3, 4, 5, 6, 7]
        group.add(things: ["Thing1", "Thing1.5", "Thing7"])
        XCTAssert(group.thingCount == 8)
        
        // add exists in different case
        group.add(thing: "THING1")
        XCTAssert(group.thingCount == 9)
        
        // insert exists in different case
        group.insert(thing: "THING2", at: 2)
        XCTAssert(group.thingCount == 10)
        
        // add multiple in different case
        group.add(things: ["THING3", "THING4"])
        XCTAssert(group.thingCount == 12)
    }
    
    func testRemoveThing() {
        // by index: [1, 2]
        let thing3 = group.remove(thing: 2)!
        XCTAssert(thing3 == "Thing3")
        XCTAssert(group.thingCount == 2)
        XCTAssert(group.indexOf(thing: "Thing3") == nil)
        
        // by name: [1]
        let thing2 = group.remove(thing: "Thing2")!
        XCTAssert(thing2 == "Thing2")
        XCTAssert(group.thingCount == 1)
        XCTAssert(group.indexOf(thing: "Thing2") == nil)
        
        // by name exists in different case - no change: [1]
        let thing1 = group.remove(thing: "THING1")
        XCTAssert(thing1 == nil)
        XCTAssert(group.thingCount == 1)
        
        // by name non existent
        let thing0 = group.remove(thing: "Thing0")
        XCTAssert(thing0 == nil)
    }
    
    func testEditThing() {
        group.edit(thing: 1, with: "ThingB")
        XCTAssert(group.thing(at: 1) == "ThingB")
        
        // new exists - no change 
        group.edit(thing: 0, with: "ThingB")
        XCTAssert(group.thing(at: 0) == "Thing1")
        
        // new exists in different case
        group.edit(thing: 0, with: "THINGB")
        XCTAssert(group.thing(at: 0) == "THINGB")
    }
}
