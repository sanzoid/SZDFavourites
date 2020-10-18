//
//  GroupList.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

typealias ThingIndex = (group: Int, thing: Int)

/**
    A **GroupList** manages a list of Groups. Groups are expected to be unique, but the class will not provide feedback if not. It is up to the managing class to provide unique groups.
 
    There is always a default group. It is expected that there is no attempt to modify or remove the default group.
    
    - Outside: Methods to manage groups, accessor to properties.
    - Inside: Directly manages groups and manages each Group by calling its methods. 
 */
final class GroupList: Codable {
    
    static let defaultGroupName = "default"
    
    private(set) var groups: [Group]
    
    var defaultGroupIndex: Int {
        return self.indexOf(group: GroupList.defaultGroupName)!
    }
    
    var defaultGroup: Group {
        return self.groups[self.defaultGroupIndex]
    }
    
    init(groups: [Group] = [Group]()) {
        self.groups = groups
        
        // add default group if doesn't exist
        if self.groups.isEmpty || self.group(with: GroupList.defaultGroupName) == nil {
            self.add(group: GroupList.defaultGroupName)
        }
    }
    
    // MARK: Group
    
    func count() -> Int {
        return self.groups.count
    }
    
    func indexOf(group name: GroupName) -> Int? {
        return self.groups.firstIndex{ $0.name == name }
    }
    
    func group(with name: GroupName) -> Group? {
        guard let index = self.indexOf(group: name) else { return nil }
        return self.groups[index]
    }
    
    func group(at index: Int) -> Group{
        return self.groups[index]
    }
    
    func exists(group name: GroupName) -> Bool {
        return self.group(with: name) != nil
    }
    
    // TODO: Default group placement - do we want it fixed at the top, at the bottom, or wherever? Do we want to insert new group based on default position?
    func add(group name: GroupName) {
        guard !self.exists(group: name) else { return }
        let group = Group(name: name)
        self.groups.append(group)
    }
    
    @discardableResult
    func remove(group name: GroupName) -> Bool {
        // prevent removing default group
        guard name != GroupList.defaultGroupName else { return false }
        
        // find group, move its things to default group, and remove
        if let index = self.indexOf(group: name) {
            self.remove(group: index)
            return true
        }
        
        return false
    }
    
    @discardableResult
    func remove(group index: Int) -> Bool {
        let group = self.groups[index]
        // prevent removing default group
        guard group.name != GroupList.defaultGroupName else { return false }
        let things = group.things
        self.defaultGroup.add(things: things)
        self.groups.remove(at: index)
        return true
    }
    
    func move(group index: Int, to newIndex: Int) {
        let group = self.groups.remove(at: index)
        self.groups.insert(group, at: newIndex)
    }
    
    func edit(group name: GroupName, with newName: GroupName) {
        guard !self.exists(group: newName) else { return }
        
        // check not editing default group
        guard name != GroupList.defaultGroupName else { return }
        
        if let index = self.indexOf(group: name) {
            self.groups[index].edit(name: newName)
        }
    }
    
    // MARK: Thing
    
    func count(in group: Int) -> Int {
        return self.groups[group].thingCount
    }
    
    func thingName(at index: ThingIndex) -> ThingName {
        return self.groups[index.group].thing(at: index.thing)
    }
    
    func indexOfThing(name: ThingName) -> ThingIndex? {
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
            return ThingIndex(groupIndex, thingIndex)
        }
        
        return nil
    }
    
    func thingExists(name: ThingName) -> Bool {
        return self.indexOfThing(name: name) != nil
    }
    
    func add(thing: ThingName) {
        // add to default group         
        self.add(thing: thing, group: GroupList.defaultGroupName)
    }
    
    func add(thing thingName: ThingName, group groupName: GroupName) {
        guard !self.thingExists(name: thingName) else { return }
        if let index = indexOf(group: groupName) {
            self.groups[index].add(thing: thingName)
        }
    }
    
    func add(thing name: ThingName, to index: ThingIndex) {
        guard !self.thingExists(name: name) else { return }
        self.groups[index.group].insert(thing: name, at: index.thing)
    }
    
    @discardableResult
    func remove(thing name: ThingName) -> ThingName? {
        if let index = self.indexOfThing(name: name) {
            return self.groups[index.group].remove(thing: index.thing)
        }
        return nil
    }
    
    func remove(thing index: ThingIndex) -> ThingName? {
        return self.groups[index.group].remove(thing: index.thing)
    }
    
    func move(thing name: ThingName, from groupName: GroupName, to newGroupName: GroupName) {
        guard self.exists(group: groupName),
            self.exists(group: newGroupName) else { return }
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
    
    func edit(thing name: ThingName, with newName: ThingName) {
        guard !self.thingExists(name: newName) else { return }
        // find it and change the name
        if let index = self.indexOfThing(name: name) {
            self.groups[index.group].edit(thing: index.thing, with: newName)
        }
    }
}
