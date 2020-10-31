//
//  ModelTests.swift
//  SZDFavouritesTests
//
//  Created by Sandy House on 2020-10-08.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import XCTest
@testable import SZDFavourites

class ModelTests: XCTestCase {
    
    var model: Model!
    
    override func setUp() {
        let thing2Item1 = Item(name: "Item2.1")
        let thing2Item2 = Item(name: "Item2.2")
        let thing1 = Thing(name: "Thing1")
        let thing2 = Thing(name: "Thing2",
                           items: [thing2Item1, thing2Item2])
        let thing3 = Thing(name: "Thing3")
        let group1 = Group(name: "GroupA")
        let group2 = Group(name: "GroupB",
                           things: [thing1.name])
        let group3 = Group(name: "GroupC",
                           things: [thing2.name,
                                    thing3.name])
        let thingMap = ThingMap(things: [thing1.name: thing1,
                                         thing2.name: thing2,
                                         thing3.name: thing3])
        let groupList = GroupList(groups: [group1,
                                           group2,
                                           group3])
        
        // A; B [1]; C [2 (2.1,2.2), 3], Default []
        model = Model(groupList: groupList, thingMap: thingMap)
    }
    
    override func tearDown() {}

    func testInit() {
        XCTAssert(model.groupCount() == 4)
        XCTAssert(model.thingCount(in: 0) == 0)
        XCTAssert(model.thingCount(in: 1) == 1)
        XCTAssert(model.thingCount(in: 2) == 2)
    }
    
    // MARK: Group
    
    func testGroupAccessors() {
        // groupCount
        XCTAssert(model.groupCount() == 4)
        
        // group at
        XCTAssert(model.group(at: 2).name == "GroupC")
    }
    
    func testGroupAdd() {
        // success
        let add1 = model.add(group: "GroupD")
        XCTAssert(add1 == nil)
        XCTAssert(model.groupCount() == 5)
        XCTAssert(model.group(at: 4).name == "GroupD")
        
        // error - name exists
        let add2 = model.add(group: "GroupB")
        XCTAssert(add2 == .groupExists)
        XCTAssert(model.groupCount() == 5)
        XCTAssert(model.group(at: 1).name == "GroupB")
        
        // error - name exists in different case
        let add3 = model.add(group: "GROUPB")
        XCTAssert(add3 == .groupExists)
        XCTAssert(model.groupCount() == 5)
        XCTAssert(model.group(at: 1).name == "GroupB")
    }
    
    func testGroupRemove() {
        // success // B[1] -> default
        XCTAssert(model.groupCount() == 4)
        XCTAssert(model.group(at: 1).name == "GroupB")
        XCTAssert(model.thingCount(in: 3) == 0)
        let remove1 = model.remove(group: "GroupB")
        XCTAssert(remove1 == nil)
        XCTAssert(model.groupCount() == 3)
        XCTAssert(model.thingCount(in: 2) == 1)
        XCTAssert(model.group(at: 1).name != "GroupB")
        
        // disregard // non-existent group
        let remove2 = model.remove(group: "GroupD")
        XCTAssert(remove2 == nil)
        XCTAssert(model.groupCount() == 3)
        
        // error // default
        let remove3 = model.remove(group: GroupList.defaultGroupName)
        XCTAssert(remove3 == .isDefault)
        XCTAssert(model.groupCount() == 3)
        XCTAssert(model.group(at: 2).name == GroupList.defaultGroupName)
    }
    
    func testGroupMove() {
        // disregard // same index
        model.move(group: 1, to: 1)
        XCTAssert(model.groupCount() == 4)
        XCTAssert(model.group(at: 1).name == "GroupB")
        
        model.move(group: 1, to: 2)
        XCTAssert(model.groupCount() == 4)
        XCTAssert(model.group(at: 2).name == "GroupB")
        XCTAssert(model.group(at: 1).name == "GroupC")
        XCTAssert(model.group(at: 2).thing(at: 0) == "Thing1")
    }
    
    func testGroupEdit() {
        // error // default
        let error1 = model.edit(group: GroupList.defaultGroupName, with: "GroupD")
        XCTAssert(error1 == .isDefault)
        XCTAssert(model.group(at: 3).name == GroupList.defaultGroupName)
        
        // error // new name exists
        let error2 = model.edit(group: "GroupA", with: "GroupB")
        XCTAssert(error2 == .groupExists)
        XCTAssert(model.group(at: 0).name == "GroupA")
        XCTAssert(model.group(at: 1).name == "GroupB")
        
        // error // new name exists in different case
        let error3 = model.edit(group: "GroupA", with: "GROUPB")
        XCTAssert(error3 == .groupExists)
        XCTAssert(model.group(at: 0).name == "GroupA")
        XCTAssert(model.group(at: 1).name == "GroupB")
        
        // disregard // same name
        let disregard1 = model.edit(group: "GroupA", with: "GroupA")
        XCTAssert(disregard1 == nil)
        XCTAssert(model.group(at: 0).name == "GroupA")
        
        // success
        let edit1 = model.edit(group: "GroupB", with: "Group2")
        XCTAssert(edit1 == nil)
        XCTAssert(model.group(at: 1).name == "Group2")
    }
    
    // MARK: Thing
    
    func testThingAccessors() {
        // thingCount
        XCTAssert(model.thingCount() == 3)
        
        // thingCount in
        XCTAssert(model.thingCount(in: 0) == 0)
        XCTAssert(model.thingCount(in: 1) == 1)
        XCTAssert(model.thingCount(in: 2) == 2)
        
        // thing at
        XCTAssert(model.thing(at: (1, 0)).name == "Thing1")
        
        // thing with name
        XCTAssert(model.thing(with: "Thing1")?.name == "Thing1")
        // different case
        XCTAssert(model.thing(with: "THING1")?.name == "Thing1")
        
        // index of thing
        XCTAssert(model.indexOfThing(name: "Thing1")! == (1, 0))
        // different case
        XCTAssert(model.indexOfThing(name: "THING1")! == (1, 0))
    }
    
    func testThingAdd() {
        let add1 = model.add(thing: "Thing4")
        XCTAssert(add1 == nil)
        XCTAssert(model.group(at: 3).thingCount == 1)
        XCTAssert(model.group(at: 3).thing(at: 0) == "Thing4")
        
        // error // exists
        let add2 = model.add(thing: "Thing2")
        XCTAssert(add2 == .thingExists)
        XCTAssert(model.group(at: 3).thingCount == 1)
        
        // error // exists in different case
        let add3 = model.add(thing: "THING2")
        XCTAssert(add3 == .thingExists)
        XCTAssert(model.group(at: 3).thingCount == 1)
    }
    
    func testThingRemove() {
        // by name
        model.remove(thing: "Thing2")
        XCTAssert(model.thing(with: "Thing2") == nil)
        XCTAssert(model.thing(at: (2,0)).name == "Thing3")
        XCTAssert(model.thingCount(in: 2) == 1)
        
        // by index
        model.remove(thing: (1, 0))
        XCTAssert(model.thing(with: "Thing1") == nil)
        XCTAssert(model.thingCount(in: 1) == 0)
    }
    
    func testThingMove() {
        // by name
        model.move(thing: "Thing1", from: "GroupB", to: "GroupC")
        XCTAssert(model.group(at: 1).thingCount == 0)
        XCTAssert(model.group(at: 2).thingCount == 3)
        XCTAssert(model.group(at: 2).thing(at: 2) == "Thing1")
        
        // disregard // same group
        model.move(thing: "Thing2", from: "GroupC", to: "GroupC")
        XCTAssert(model.group(at: 2).thingCount == 3)
        XCTAssert(model.group(at: 2).thing(at: 0) == "Thing2")
        
        // by index
        model.move(thing: (2,2), to: (2,0))
        XCTAssert(model.group(at: 2).thingCount == 3)
        XCTAssert(model.group(at: 2).thing(at: 0) == "Thing1")
        
        // disregard // same index
        model.move(thing: (2,0), to: (2,0))
        XCTAssert(model.group(at: 2).thingCount == 3)
        XCTAssert(model.group(at: 2).thing(at: 0) == "Thing1")
    }
    
    func testThingEdit() {
        // diregard // same name
        let disregard1 = model.edit(thing: "Thing2", with: "Thing2")
        XCTAssert(disregard1 == nil)
        XCTAssert(model.thing(with: "Thing2") != nil)
        XCTAssert(model.thing(at: (2,0)).itemCount() == 2)
        
        // error // exists
        let error1 = model.edit(thing: "Thing2", with: "Thing3")
        XCTAssert(error1 == .thingExists)
        XCTAssert(model.thing(at: (2,0)).name == "Thing2")
        
        // success // same name, different case
        let edit1 = model.edit(thing: "Thing2", with: "THING2")
        XCTAssert(edit1 == nil)
        XCTAssert(model.thing(at: (2,0)).name == "THING2")
        XCTAssert(model.thing(at: (2,0)).itemCount() == 2)
        
        // success // different name
        let edit2 = model.edit(thing: "THING2", with: "ThingB")
        XCTAssert(edit2 == nil)
        XCTAssert(model.thing(at: (2,0)).name == "ThingB")
        XCTAssert(model.thing(at: (2,0)).itemCount() == 2)
    }
    
    // MARK: Item
    
    func testItemAccessors() {
        // itemCount
        XCTAssert(model.itemCount(for: "Thing1") == 0)
        XCTAssert(model.itemCount(for: "Thing2") == 2)
        
        // item at
        XCTAssert(model.item(at: 0, for: "Thing2").name == "Item2.1")
    }
    
    func testItemAdd() {
        // error // exists for thing
        let error1 = model.add(item: "Item2.1", to: "Thing2")
        XCTAssert(error1 == .itemExists)
        XCTAssert(model.thing(at: (2,0)).itemCount() == 2)
        XCTAssert(model.thing(at: (2,0)).item(at: 0).name == "Item2.1")
        
        // error // exists in different case
        let error2 = model.add(item: "ITEM2.1", to: "Thing2")
        XCTAssert(error2 == .itemExists)
        XCTAssert(model.thing(at: (2,0)).itemCount() == 2)
        XCTAssert(model.thing(at: (2,0)).item(at: 0).name == "Item2.1")
        
        // success
        let add1 = model.add(item: "Item1.1", to: "Thing1")
        XCTAssert(add1 == nil)
        XCTAssert(model.thing(at: (1,0)).itemCount() == 1)
        XCTAssert(model.thing(at: (1,0)).item(at: 0).name == "Item1.1")
    }
    
    func testItemRemove() {
        XCTAssert(model.thing(at: (2,0)).itemCount() == 2)
        XCTAssert(model.thing(at: (2,0)).item(at: 0).name == "Item2.1")
        model.remove(item: 0, for: "Thing2")
        XCTAssert(model.thing(at: (2,0)).itemCount() == 1)
        XCTAssert(model.thing(at: (2,0)).item(at: 0).name == "Item2.2")
    }
    
    func testItemMove() {
        // disregard // same index
        model.move(item: 0, for: "Thing2", to: 0)
        XCTAssert(model.thing(at: (2,0)).item(at: 0).name == "Item2.1")
        XCTAssert(model.thing(at: (2,0)).item(at: 1).name == "Item2.2")
        
        // success
        model.move(item: 0, for: "Thing2", to: 1)
        XCTAssert(model.thing(at: (2,0)).item(at: 0).name == "Item2.2")
        XCTAssert(model.thing(at: (2,0)).item(at: 1).name == "Item2.1")
    }
    
    func testItemEdit() {
        // name
        // disregard // same name
        XCTAssert(model.thing(with: "Thing2")?.item(at: 0).name == "Item2.1")
        let disregard1 = model.edit(item: 0, for: "Thing2", with: "Item2.1")
        XCTAssert(disregard1 == nil)
        XCTAssert(model.thing(with: "Thing2")?.item(at: 0).name == "Item2.1")
        
        // error // new exists
        let error1 = model.edit(item: 0, for: "Thing2", with: "Item2.2")
        XCTAssert(error1 == .itemExists)
        XCTAssert(model.thing(with: "Thing2")?.item(at: 0).name == "Item2.1")
        
        // error // new exists in different case
        let error2 = model.edit(item: 0, for: "Thing2", with: "ITEM2.2")
        XCTAssert(error2 == .itemExists)
        XCTAssert(model.thing(with: "Thing2")?.item(at: 0).name == "Item2.1")
        
        // success // same name, different case
        let edit1 = model.edit(item: 0, for: "Thing2", with: "ITEM2.1")
        XCTAssert(edit1 == nil)
        XCTAssert(model.thing(with: "Thing2")?.item(at: 0).name == "ITEM2.1")
        
        // success // different name
        let edit2 = model.edit(item: 0, for: "Thing2", with: "ItemA")
        XCTAssert(edit2 == nil)
        XCTAssert(model.thing(with: "Thing2")?.item(at: 0).name == "ItemA")
        
        // image
        let image = UIImage()
        model.edit(item: 0, for: "Thing2", with: image)
        XCTAssert(model.thing(at: (2,0)).item(at: 0).image == image)
    }
}
