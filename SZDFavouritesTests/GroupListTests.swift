//
//  GroupListTests.swift
//  SZDFavouritesTests
//
//  Created by Sandy House on 2020-10-07.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import XCTest
@testable import SZDFavourites

class GroupListTests: XCTestCase {

    let group1 = Group(name: "Group1")
    let group2 = Group(name: "Group2", things: ["Thing1", "Thing2"])
    let group3 = Group(name: "Group3", things: ["ThingA", "ThingB", "ThingC"])
    var groupList: GroupList!
    
    override func setUp() {
        // [], [1,2], [A,B,C], []
        groupList = GroupList(groups: [group1, group2, group3])
    }

    override func tearDown() {}

    func testInit() {
        // no groups -> default
        let groupList1 = GroupList()
        XCTAssert(groupList1.groups.count == 1)
        
        // groups with no default -> groups + default
        let groupList2 = GroupList(groups: [Group(name: "Group1")])
        XCTAssert(groupList2.groups.count == 2)
        XCTAssert(groupList2.groups[0].name == "Group1")
        XCTAssert(groupList2.groups[1].name == GroupList.defaultGroupName)
        
        // groups with default -> groups
        let groupList3 = GroupList(groups: [Group(name: "Group1"), Group(name: GroupList.defaultGroupName)])
        XCTAssert(groupList3.groups.count == 2)
        XCTAssert(groupList3.groups[0].name == "Group1")
        XCTAssert(groupList3.groups[1].name == GroupList.defaultGroupName)
    }
    
    func testGetters() {
        // count
        XCTAssert(groupList.count() == 4)
        
        // indexOf
        XCTAssert(groupList.indexOf(group: "Group1") == 0)
        XCTAssert(groupList.indexOf(group: "Group2") == 1)
        XCTAssert(groupList.indexOf(group: "Group3") == 2)
        XCTAssert(groupList.indexOf(group: GroupList.defaultGroupName) == 3)
        XCTAssert(groupList.indexOf(group: "Group4") == nil)
        
        // subscript
        XCTAssert(groupList.group(at: 0).name == "Group1")
        XCTAssert(groupList.group(at: 1).name == "Group2")
        XCTAssert(groupList.group(at: 2).name == "Group3")
        XCTAssert(groupList.group(at: 3).name == GroupList.defaultGroupName)
        
        // group with
        XCTAssert(groupList.group(with: "Group1") == group1)
        XCTAssert(groupList.group(with: "Group2") == group2)
        XCTAssert(groupList.group(with: "Group3") == group3)
        
        // count in group
        XCTAssert(groupList.count(in: 0) == 0)
        XCTAssert(groupList.count(in: 1) == 2)
        XCTAssert(groupList.count(in: 2) == 3)
        XCTAssert(groupList.count(in: 3) == 0)
        
        // indexOfThing
        XCTAssert(groupList.indexOfThing(name: "Thing2")! == (1, 1))
        XCTAssert(groupList.indexOfThing(name: "ThingX") == nil)
        
        // thingName at index
        XCTAssert(groupList.thingName(at: (1, 1)) == "Thing2")
        XCTAssert(groupList.thingName(at: (2, 0)) == "ThingA")
        XCTAssert(groupList.thingName(at: (2, 2)) == "ThingC")
        
        // default
        XCTAssert(groupList.defaultGroupIndex == 3)
        XCTAssert(groupList.defaultGroup == groupList.group(at: 3))
        
        // exists
        XCTAssert(groupList.exists(group: "Group1"))
        XCTAssert(!groupList.exists(group: "GroupA"))
        
        // thing exists
        XCTAssert(groupList.thingExists(name: "Thing1"))
        XCTAssert(!groupList.thingExists(name: "ThingOne"))
    }
    
    // MARK: Group
    
    func testGroupRemove() {
        // by index [1, 2, default]
        XCTAssert(groupList.group(at: 2).name == "Group3")
        let group3Removed = groupList.remove(group: 2)
        XCTAssert(group3Removed)
        XCTAssert(groupList.count() == 3)
        XCTAssert(groupList.indexOf(group: "Group3") == nil)
        // by name [1, default]
        let group2Removed = groupList.remove(group: "Group2")
        XCTAssert(group2Removed)
        XCTAssert(groupList.count() == 2)
        XCTAssert(groupList.indexOf(group: "Group2") == nil)
        // default [1, default]
        let groupDefaultRemoved = groupList.remove(group: 1)
        XCTAssert(!groupDefaultRemoved)
        XCTAssert(groupList.count() == 2)
        XCTAssert(groupList.indexOf(group: GroupList.defaultGroupName) == 1)
    }
    
    func testGroupAdd() {
        // [1, 2, 3, default, 4]
        groupList.add(group: "Group4")
        XCTAssert(groupList.group(at: 4).name == "Group4")
        
        // exists
        groupList.add(group: "Group1")
        XCTAssert(groupList.count() == 5)
        XCTAssert(groupList.group(at: 0).name == "Group1")
    }
    
    func testGroupMove() {
        groupList.move(group: 1, to: 2)
        XCTAssert(groupList.count() == 4)
        XCTAssert(groupList.group(at: 2).name == "Group2")
        XCTAssert(groupList.group(at: 1).name == "Group3")
        XCTAssert(groupList.group(at: 2).thing(at: 0) == "Thing1")
    }
    
    func testGroupEdit() {
        groupList.edit(group: "Group2", with: "GroupB")
        XCTAssert(groupList.count() == 4)
        XCTAssert(groupList.indexOf(group: "GroupB") == 1)
        XCTAssert(groupList.group(with: "Group2") == nil)
        
        // non-existent
        groupList.edit(group: "GroupX", with: "GroupY")
        XCTAssert(groupList.count() == 4)
        XCTAssert(groupList.group(with: "GroupX") == nil)
        XCTAssert(groupList.group(with: "GroupY") == nil)
        
        // new name already exists
        groupList.edit(group: "Group3", with: "Group1")
        XCTAssert(groupList.count() == 4)
        XCTAssert(groupList.indexOf(group: "Group1") == 0)
        XCTAssert(groupList.indexOf(group: "Group3") == 2)
    }
    
    // MARK: Thing
    
    func testThingRemove() {
        // by name      [], [2], [A,B,C], []
        let thing1 = groupList.remove(thing: "Thing1")!
        XCTAssert(thing1 == "Thing1")
        XCTAssert(groupList.group(with: "Thing1") == nil)
        
        // by index     [], [], [A,B,C], []
        let thing2 = groupList.remove(thing: (1, 0))!
        XCTAssert(thing2 == "Thing2")
        XCTAssert(groupList.group(with: thing2) == nil)
        
        // non-existent [], [], [A,B,C], []
        XCTAssert(groupList.group(with: "ThingX") == nil)
        let thingX = groupList.remove(thing: "ThingX")
        XCTAssert(thingX == nil)
        XCTAssert(groupList.group(with: "ThingX") == nil)
    }
    
    func testThingAdd() {
        // to default   [], [1, 2], [A,B,C], [a]
        groupList.add(thing: "Thinga")
        XCTAssert(groupList.group(at: 3).thingCount == 1)
        XCTAssert(groupList.group(at: 3).thing(at: 0) == "Thinga")
        XCTAssert(groupList.indexOfThing(name: "Thinga")?.group == groupList.indexOf(group: GroupList.defaultGroupName))
        
        // to group     [], [1,2,3], [A,B,C], [a]
        groupList.add(thing: "Thing3", group: "Group2")
        XCTAssert(groupList.group(at: 1).thingCount == 3)
        XCTAssert(groupList.group(at: 1).thing(at: 2) == "Thing3")
        
        // to index     [], [1,1.5,2,3], [A,B,C], [a]
        groupList.add(thing: "Thing1.5", to: (1, 1))
        XCTAssert(groupList.group(at: 1).thingCount == 4)
        XCTAssert(groupList.group(at: 1).thing(at: 1) == "Thing1.5")
        
        // to group, exists
        groupList.add(thing: "Thing3", group: "Group2")
        XCTAssert(groupList.group(at: 1).thingCount == 4)
        XCTAssert(groupList.group(at: 1).thing(at: 3) == "Thing3")
        
        // to index, exists
        groupList.add(thing: "Thing1.5", to: (1, 1))
        XCTAssert(groupList.group(at: 1).thingCount == 4)
        XCTAssert(groupList.group(at: 1).thing(at: 1) == "Thing1.5")
    }
    
    func testThingMove() {
        // with group name  [], [1,2,C], [A,B]
        groupList.move(thing: "ThingC", from: "Group3", to: "Group2")
        XCTAssert(groupList.group(at: 2).thingCount == 2)
        XCTAssert(groupList.group(at: 1).thingCount == 3)
        XCTAssert(groupList.indexOfThing(name: "ThingC")! == (1, 2))
        
        // with index       [B], [1,2,C], [A]
        groupList.move(thing: (2, 1), to: (0, 0))
        XCTAssert(groupList.group(at: 2).thingCount == 1)
        XCTAssert(groupList.group(at: 0).thingCount == 1)
        XCTAssert(groupList.indexOfThing(name: "ThingB")! == (0, 0))
        
        // non-existent thing
        groupList.move(thing: "ThingX", from: "Group3", to: "Group2")
        XCTAssert(groupList.indexOfThing(name: "ThingX") == nil)
        
        // non-existent from group
        groupList.move(thing: "ThingC", from: "Group2", to: "GroupX")
        XCTAssert(groupList.indexOfThing(name: "ThingC")! == (1, 2))
        
        // non-existent to group
        groupList.move(thing: "ThingC", from: "GroupX", to: "Group3")
        XCTAssert(groupList.indexOfThing(name: "ThingC")! == (1, 2))
    }
    
    func testThingEdit() {
        groupList.edit(thing: "Thing1", with: "ThingOne")
        XCTAssert(groupList.indexOfThing(name: "Thing1") == nil)
        XCTAssert(groupList.indexOfThing(name: "ThingOne")! == (1, 0))
        
        // non-existent
        groupList.edit(thing: "ThingX", with: "ThingY")
        XCTAssert(groupList.indexOfThing(name: "ThingX") == nil)
        XCTAssert(groupList.indexOfThing(name: "ThingY") == nil)
        
        // thing already exists
        groupList.edit(thing: "ThingA", with: "ThingB")
        XCTAssert(groupList.indexOfThing(name: "ThingA")! == (2, 0))
        XCTAssert(groupList.indexOfThing(name: "ThingB")! == (2, 1))
        
        // default group
        groupList.edit(thing: GroupList.defaultGroupName, with: "Default2")
        XCTAssert(groupList.exists(group: GroupList.defaultGroupName))
        XCTAssert(!groupList.exists(group: "Default2"))
    }
}
