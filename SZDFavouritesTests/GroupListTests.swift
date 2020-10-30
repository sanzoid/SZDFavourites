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
    
    func testGroup() {
        // default
        XCTAssert(groupList.defaultGroupIndex == 3)
        XCTAssert(groupList.defaultGroup == groupList.group(at: 3))
                
        // count
        XCTAssert(groupList.count() == 4)
        
        // indexOf
        XCTAssert(groupList.indexOf(group: "Group1") == 0)
        XCTAssert(groupList.indexOf(group: "Group2") == 1)
        XCTAssert(groupList.indexOf(group: "Group3") == 2)
        XCTAssert(groupList.indexOf(group: GroupList.defaultGroupName) == 3)
        XCTAssert(groupList.indexOf(group: "Group4") == nil)
        // case sensitive
        XCTAssert(groupList.indexOf(group: "GROUP1") == nil)
        // case insensitive
        XCTAssert(groupList.indexOf(group: "GROUP1", caseSensitive: false) == 0)
        
        // group at
        XCTAssert(groupList.group(at: 0).name == "Group1")
        XCTAssert(groupList.group(at: 1).name == "Group2")
        XCTAssert(groupList.group(at: 2).name == "Group3")
        XCTAssert(groupList.group(at: 3).name == GroupList.defaultGroupName)
        
        // group with
        XCTAssert(groupList.group(with: "Group1") == group1)
        XCTAssert(groupList.group(with: "Group2") == group2)
        XCTAssert(groupList.group(with: "Group3") == group3)
        // case sensitive
        XCTAssert(groupList.group(with: "GROUP1") == nil)
        // case insensitive
        XCTAssert(groupList.group(with: "GROUP1", caseSensitive: false) == group1)
        
        // group exists
        XCTAssert(groupList.exists(group: "Group1"))
        XCTAssert(!groupList.exists(group: "GroupA"))
        // case sensitive
        XCTAssert(!groupList.exists(group: "GROUP1"))
        // case insensitive
        XCTAssert(groupList.exists(group: "GROUP1", caseSensitive: false))
    }
    
    func testThing() {
        // count in group
        XCTAssert(groupList.count(in: 0) == 0)
        XCTAssert(groupList.count(in: 1) == 2)
        XCTAssert(groupList.count(in: 2) == 3)
        XCTAssert(groupList.count(in: 3) == 0)
        
        // thingName at index
        XCTAssert(groupList.thingName(at: (1, 1)) == "Thing2")
        XCTAssert(groupList.thingName(at: (2, 0)) == "ThingA")
        XCTAssert(groupList.thingName(at: (2, 2)) == "ThingC")
        
        // indexOfThing
        XCTAssert(groupList.indexOfThing(name: "Thing2")! == (1, 1))
        XCTAssert(groupList.indexOfThing(name: "ThingX") == nil)
        // case sensitive
        XCTAssert(groupList.indexOfThing(name: "THING2") == nil)
        // case insensitive
        XCTAssert(groupList.indexOfThing(name: "Thing2", caseSensitive: false)! == (1, 1))
        
        // thing exists
        XCTAssert(groupList.thingExists(name: "Thing1"))
        XCTAssert(!groupList.thingExists(name: "ThingOne"))
        // case sensitive
        XCTAssert(!groupList.thingExists(name: "THING1"))
        // case insensitive
        XCTAssert(groupList.thingExists(name: "THING1", caseSensitive: false))
    }
    
    // MARK: Group
    
    func testGroupAdd() {
        // [1, 2, 3, default, 4]
        groupList.add(group: "Group4")
        XCTAssert(groupList.count() == 5)
        XCTAssert(groupList.group(at: 4).name == "Group4")
        
        // exists - no change
        groupList.add(group: "Group1")
        XCTAssert(groupList.count() == 5)
        
        // exists in different case: [1, 2, 3, default, 4, 1]
        groupList.add(group: "GROUP1")
        XCTAssert(groupList.count() == 6)
        XCTAssert(groupList.group(at: 5).name == "GROUP1")
        
    }
    
    func testGroupRemove() {
        // by index: [1, 2, default]
        XCTAssert(groupList.group(at: 2).name == "Group3")
        let group3Removed = groupList.remove(group: 2)
        XCTAssert(group3Removed)
        XCTAssert(groupList.count() == 3)
        XCTAssert(!groupList.exists(group: "Group3"))
        
        // by name: [1, default]
        let group2Removed = groupList.remove(group: "Group2")
        XCTAssert(group2Removed)
        XCTAssert(groupList.count() == 2)
        XCTAssert(!groupList.exists(group: "Group2"))
        
        // by name with different case / non-existent - no change: [1, default]
        let group1Removed = groupList.remove(group: "GROUP1")
        XCTAssert(!group1Removed)
        XCTAssert(groupList.count() == 2)
        XCTAssert(groupList.exists(group: "Group1"))
        
        // by index default - no change: [1, default]
        var groupDefaultRemoved = groupList.remove(group: 1)
        XCTAssert(!groupDefaultRemoved)
        XCTAssert(groupList.count() == 2)
        XCTAssert(groupList.exists(group: GroupList.defaultGroupName))
        
        // by name default - no change
        groupDefaultRemoved = groupList.remove(group: GroupList.defaultGroupName)
        XCTAssert(!groupDefaultRemoved)
        XCTAssert(groupList.count() == 2)
        XCTAssert(groupList.exists(group: GroupList.defaultGroupName))
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
        XCTAssert(groupList.exists(group: "GroupB"))
        XCTAssert(!groupList.exists(group: "Group2"))
        
        // same but different case
        groupList.edit(group: "GroupB", with: "GROUPB")
        XCTAssert(groupList.count() == 4)
        XCTAssert(groupList.exists(group: "GROUPB"))
        XCTAssert(!groupList.exists(group: "GroupB"))
        
        // non-existent - no change
        groupList.edit(group: "GroupX", with: "GroupY")
        XCTAssert(groupList.count() == 4)
        XCTAssert(!groupList.exists(group: "GroupX"))
        XCTAssert(!groupList.exists(group: "GroupY"))
        
        // new name already exists - no change
        groupList.edit(group: "Group3", with: "Group1")
        XCTAssert(groupList.count() == 4)
        XCTAssert(groupList.indexOf(group: "Group1") == 0)
        XCTAssert(groupList.indexOf(group: "Group3") == 2)
        
        // new name exists in different case
        groupList.edit(group: "Group3", with: "GROUP1")
        XCTAssert(groupList.count() == 4)
        XCTAssert(groupList.indexOf(group: "Group1") == 0)
        XCTAssert(groupList.indexOf(group: "GROUP1") == 2)
        XCTAssert(!groupList.exists(group: "Group3"))
    }
    
    // MARK: Thing
    
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
        
        // to group, exists - no change
        groupList.add(thing: "Thing3", group: "Group2")
        XCTAssert(groupList.group(at: 1).thingCount == 4)
        XCTAssert(groupList.group(at: 1).thing(at: 3) == "Thing3")
        
        // to index, exists - no change
        groupList.add(thing: "Thing1.5", to: (1, 1))
        XCTAssert(groupList.group(at: 1).thingCount == 4)
        XCTAssert(groupList.group(at: 1).thing(at: 1) == "Thing1.5")
        
        // to group, exists in different case
        groupList.add(thing: "THING3", group: "Group2")
        XCTAssert(groupList.group(at: 1).thingCount == 5)
        XCTAssert(groupList.group(at: 1).thing(at: 4) == "THING3")
        
        // to index, exists in different case
        groupList.add(thing: "THING1.5", to: (1, 1))
        XCTAssert(groupList.group(at: 1).thingCount == 6)
        XCTAssert(groupList.group(at: 1).thing(at: 1) == "THING1.5")
    }
    
    func testThingRemove() {
        // by name      [], [2], [A,B,C], []
        let thing1 = groupList.remove(thing: "Thing1")!
        XCTAssert(thing1 == "Thing1")
        XCTAssert(groupList.group(with: "Thing1") == nil)
        
        // by index     [], [], [A,B,C], []
        let thing2 = groupList.remove(thing: (1, 0))!
        XCTAssert(thing2 == "Thing2")
        XCTAssert(groupList.group(with: thing2) == nil)
        
        // non-existent - no change [], [], [A,B,C], []
        XCTAssert(groupList.group(with: "ThingX") == nil)
        let thingX = groupList.remove(thing: "ThingX")
        XCTAssert(thingX == nil)
        XCTAssert(groupList.group(with: "ThingX") == nil)
        
        // by name exists in different case - no change
        let thingA = groupList.remove(thing: "THINGA")
        XCTAssert(thingA == nil)
        XCTAssert(groupList.thingExists(name: "ThingA"))
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
        
        // non-exists - different case
        XCTAssert(groupList.indexOfThing(name: "Thing1")! == (1, 0))
        groupList.move(thing: "THING1", from: "Group2", to: "Group3")
        XCTAssert(groupList.indexOfThing(name: "Thing1")! == (1, 0))
    }
    
    func testThingEdit() {
        groupList.edit(thing: "Thing1", with: "ThingOne")
        XCTAssert(!groupList.thingExists(name: "Thing1"))
        XCTAssert(groupList.indexOfThing(name: "ThingOne")! == (1, 0))
        
        // different case
        groupList.edit(thing: "ThingOne", with: "THINGONE")
        XCTAssert(!groupList.thingExists(name: "ThingOne"))
        XCTAssert(groupList.indexOfThing(name: "THINGONE")! == (1, 0))
        
        // non-existent
        groupList.edit(thing: "ThingX", with: "ThingY")
        XCTAssert(groupList.indexOfThing(name: "ThingX") == nil)
        XCTAssert(groupList.indexOfThing(name: "ThingY") == nil)
        
        // new exists - no change
        groupList.edit(thing: "ThingA", with: "ThingB")
        XCTAssert(groupList.indexOfThing(name: "ThingA")! == (2, 0))
        XCTAssert(groupList.indexOfThing(name: "ThingB")! == (2, 1))
        
        // new exists in different case
        groupList.edit(thing: "ThingA", with: "THINGB")
        XCTAssert(!groupList.thingExists(name: "ThingA"))
        XCTAssert(groupList.indexOfThing(name: "THINGB")! == (2, 0))
        XCTAssert(groupList.indexOfThing(name: "ThingB")! == (2, 1))
        
        // default group
        groupList.edit(thing: GroupList.defaultGroupName, with: "Default2")
        XCTAssert(groupList.exists(group: GroupList.defaultGroupName))
        XCTAssert(!groupList.exists(group: "Default2"))
    }
}
