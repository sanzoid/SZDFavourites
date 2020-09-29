//
//  Manager.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-28.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

class Manager {
    
    /**
        **GroupList**

        A GroupList is an array of groups. Groups have an ordered list of things (name only).

        - A group can be added
        - A group can be removed
        - A group's name can be changed
        - A thing (name) can move between groups.
     */
    private var groupList: GroupList2
    
    /**
        **ThingMap**

        A ThingMap is a dictionary of thingNames to things.

        - A thing can be added
        - A thing can be removed
        - A thing can be edited (name, properties)

        When a thing is added or removed, it must be updated in the groupList.
        When a thing's name is changed, its key must be changed in the thingMap.
    */
    private var thingMap: ThingMap
    
    init(groupList: GroupList2, thingMap: ThingMap) {
        self.groupList = groupList
        self.thingMap = thingMap
    }
    
    // MARK: Group
    
    func add(group name: GroupName) {
        self.groupList.add(group: name)
    }
    
    func remove(group name: GroupName) {
        self.groupList.remove(group: name)
    }
    
    func edit(group name: GroupName, with newName: GroupName) {
        self.groupList.edit(group: name, with: newName)
    }
    
    func move(thing name: ThingName, from groupName: GroupName, to newGroupName: GroupName) {
        self.groupList.move(thing: name, from: groupName, to: newGroupName)
    }
    
    // MARK: Thing
    
    func add(thing name: ThingName) {
        let thing = Thing(name: name)
        
        self.thingMap.add(thing: thing)
        self.groupList.add(thing: thing)
    }
    
    func remove(thing name: ThingName) {
        self.thingMap.remove(thing: name)
        self.groupList.remove(thing: name)
    }
    
    func edit(thing: Thing, with newThing: Thing) {
        let isNewName = thing.name != newThing.name
        
        // edit object in thingMap
        self.thingMap.edit(thing: thing, with: newThing, isNewName: isNewName)
        
        // edit name in groupList
        if isNewName {
            self.groupList.edit(thing: thing.name, with: newThing.name)
        }
    }
}
