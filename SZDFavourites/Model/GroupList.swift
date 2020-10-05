//
//  GroupList.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

typealias ThingIndex = (groupIndex: Int, thingIndex: Int)

/**
    A **GroupList** manages a list of Groups.
    
    - Outside: Methods to manage groups, accessor to properties.
    - Inside: Directly manages groups and manages each Group by calling its methods. 
 */
class GroupList: Codable {
    
    static let defaultGroupName = "default"
    
    private(set) var groups: [Group]
    
    var defaultGroup: Group {
        return self.groups[self.indexOf(group: GroupList.defaultGroupName)!]
    }
    
    init(groups: [Group] = [Group]()) {
        self.groups = groups
        
        if self.groups.isEmpty {
            let defaultGroup = Group(name: GroupList.defaultGroupName)
            self.groups.append(defaultGroup)
        }
    }
    
    // MARK: Group
    
    func count() -> Int {
        return self.groups.count
    }
    
    subscript(index: Int) -> Group {
        return self.groups[index]
    }
    
    func add(group name: GroupName) {
        let group = Group(name: name)
        self.groups.append(group)
    }
    
    @discardableResult
    func remove(group name: GroupName) -> Bool {
        // find group, move its things to default group, and remove
        if let index = self.indexOf(group: name) {
            self.remove(group: index)
            return true
        }
        
        return false
    }
    
    func remove(group index: Int) {
        let things = self.groups[index].things
        self.defaultGroup.add(things: things)
        self.groups.remove(at: index)
    }
    
    func edit(group name: GroupName, with newName: GroupName) {
        if let index = self.indexOf(group: name) {
            self.groups[index].edit(name: newName)
        }
    }
    
    // MARK: Thing
    
    func count(in group: Int) -> Int {
        return self.groups[group].count
    }
    
    func add(thing: Thing) {
        // add to default group         
        self.add(thing: thing.name, group: GroupList.defaultGroupName)
    }
    
    func add(thing thingName: ThingName, group groupName: GroupName) {
        if let index = indexOf(group: groupName) {
            self.groups[index].add(thing: thingName)
        }
    }
    
    func add(thing name: ThingName, to index: ThingIndex) {
        self.groups[index.groupIndex].add(thing: name, to: index.thingIndex)
    }
    
    @discardableResult
    func remove(thing name: ThingName) -> ThingName? {
        if let index = self.indexOfThing(name: name) {
            return self.groups[index.group].remove(thing: index.thing)
        }
        
        return nil
    }
    
    func remove(thing index: ThingIndex) -> ThingName? {
        return self.groups[index.groupIndex].remove(thing: index.thingIndex)
    }
    
    func edit(thing name: ThingName, with newName: ThingName) {
        // find it and change the name
        if let index = self.indexOfThing(name: name) {
            self.groups[index.group].edit(thing: index.thing, with: newName)
        }
    }
    
    func move(thing name: ThingName, from groupName: GroupName, to newGroupName: GroupName) {
        // remove from old group and add to new group
        if let thing = self.remove(thing: name) {
            self.add(thing: thing, group: newGroupName)
        }
    }
    
    func move(thing index: ThingIndex, to newIndex: ThingIndex) {
        // remove from old location, add to new location
        if let thing = self.remove(thing: index) {
            self.add(thing: thing, to: newIndex)
        }
    }
    
    func thingName(at index: ThingIndex) -> ThingName {
        return self.groups[index.groupIndex].things[index.thingIndex]
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
