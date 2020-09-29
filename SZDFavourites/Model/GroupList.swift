//
//  GroupList.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//
//  A GroupList is an abstraction of a list of Groups.

import UIKit

typealias ThingIndex = (groupIndex: Int, thingIndex: Int)

class GroupList: Codable {
    var groups: [Group]
    
    var count: Int {
        return self.groups.count
    }
    
    var defaultGroup: Group {
        return self.groups.first!
    }
    
    init() {
        self.groups = [Group]()
        
        let defaultGroup = Group(name: "Default")
        self.groups.append(defaultGroup)
    }
    
    subscript(index: Int) -> Group {
        return self.groups[index]
    }
    
    @discardableResult
    func remove(thing: Thing) -> Bool {
        for group in self.groups {
            if group.remove(thing: thing) {
                return true
            }
        }
        return false
    }
}

class GroupList2 {
    
    static let defaultGroupName = "default"
    
    private var groups: [Group2]
    
    var defaultGroup: Group2 {
        return self.groups[self.indexOf(group: GroupList2.defaultGroupName)!]
    }
    
    init(groups: [Group2] = [Group2]()) {
        self.groups = groups
        
        if self.groups.isEmpty {
            let defaultGroup = Group2(name: GroupList2.defaultGroupName)
            self.groups.append(defaultGroup)
        }
    }
    
    // MARK: Group
    
    func add(group name: GroupName) {
        let group = Group2(name: name)
        self.groups.append(group)
    }
    
    @discardableResult
    func remove(group name: GroupName) -> Bool {
        // find group, move its things to default group, and remove
        if let index = self.indexOf(group: name) {
            let things = self.groups[index].things
            self.defaultGroup.add(things: things)
            self.groups.remove(at: index)
            return true
        }
        
        return false
    }
    
    func edit(group name: GroupName, with newName: GroupName) {
        if let index = self.indexOf(group: name) {
            self.groups[index].name = newName
        }
    }
    
    // MARK: Thing
    
    func add(thing: Thing) {
        // add to default group         
        self.add(thing: thing.name, group: GroupList2.defaultGroupName)
    }
    
    func add(thing thingName: ThingName, group groupName: GroupName) {
        if let index = indexOf(group: groupName) {
            self.groups[index].add(thing: thingName)
        }
    }
    
    @discardableResult
    func remove(thing name: ThingName) -> ThingName? {
        // TODO: refactor to use indexOf
        // find group it's in
        for group in self.groups {
            if let thing = group.remove(thing: name) {
                return thing
            }
        }
        
        return nil
    }
    
    func edit(thing name: ThingName, with newName: ThingName) {
        // find it and change the name
        if let index = self.indexOfThing(name: name) {
            self.groups[index.group].things[index.thing] = newName
        }
    }
    
    func move(thing name: ThingName, from groupName: GroupName, to newGroupName: GroupName) {
        // remove from old group and add to new group
        if let thing = self.remove(thing: name) {
            self.add(thing: thing, group: newGroupName)
        }
    }
    
    // MARK: Helper
    
    private func indexOf(group name: GroupName) -> Int? {
        return self.groups.firstIndex{ $0.name == name }
    }
    
    private func indexOfThing(name: ThingName) -> (group: Int, thing: Int)? {
        // find the group it's in, find index in things
        var groupIndex: Int = 0
        var thingIndex: Int? = nil
        
        for group in self.groups {
            if let index = group.indexOf(thing: name) {
                thingIndex = index
                break
            }
            groupIndex += 1
        }
        
        if let thingIndex = thingIndex {
            return (groupIndex, thingIndex)
        }
        
        return nil
    }
}
