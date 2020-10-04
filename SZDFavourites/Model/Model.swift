//
//  Model.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-28.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

class Model: Codable {
    
    /**
        **GroupList**

        A GroupList is an array of groups. Groups have an ordered list of things (name only).

        - A group can be added
        - A group can be removed
        - A group's name can be changed
        - A thing (name) can move between groups.
     */
    private var groupList: GroupList
    
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
    
    init(groupList: GroupList, thingMap: ThingMap) {
        self.groupList = groupList
        self.thingMap = thingMap
    }
    
    // MARK: Group
    
    func groupCount() -> Int {
        return self.groupList.count()
    }
    
    func add(group name: GroupName) {
        self.groupList.add(group: name)
    }
    
    func remove(group name: GroupName) {
        self.groupList.remove(group: name)
    }
    
    func remove(group index: Int) {
        self.groupList.remove(group: index)
    }
    
    func edit(group name: GroupName, with newName: GroupName) {
        self.groupList.edit(group: name, with: newName)
    }
    
    func move(thing name: ThingName, from groupName: GroupName, to newGroupName: GroupName) {
        self.groupList.move(thing: name, from: groupName, to: newGroupName)
    }
    
    func move(thing index: ThingIndex, to newIndex: ThingIndex) {
        self.groupList.move(thing: index, to: newIndex)
    }
    
    func group(at index: Int) -> Group? {
        return self.groupList[index]
    }
    
    // MARK: Thing
    
    func thingCount(in group: Int) -> Int {
        self.groupList.count(in: group)
    }
    
    func add(thing name: ThingName) {
        let thing = Thing(name: name)
        self.add(thing: thing)
    }
    
    func add(thing: Thing) {
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
    
    func thing(at index: ThingIndex) -> Thing? {
        let name = self.groupList.thingName(at: index)
        let thing = self.thingMap[name]
        return thing
    }
    
    // MARK: Item
    
    func add(item name: ItemName, to thing: Thing) {
        self.thingMap[thing.name]?.addItem(name: name)
    }
    
    func edit(item index: Int, for thing: Thing, with newName: ItemName) {
        self.thingMap[thing.name]?.edit(item: index, with: newName)
    }
    
    func move(item index: Int, for thing: Thing, to newIndex: Int) {
        self.thingMap[thing.name]?.move(item: index, to: newIndex)
    }
    
    func remove(item index: Int, for thing: Thing) {
        self.thingMap[thing.name]?.removeItem(at: index)
    }
    
    // MARK: Peristence
    // TODO: move this out 
    
    static func retrieve() -> Model {
        let defaults = UserDefaults.standard
        
        if let data = defaults.object(forKey: "Model") as? Data {
            let decoder = JSONDecoder()
            if let model = try? decoder.decode(Model.self, from: data) {
                return model
            }
        }
        
        // default model
        let groupList = GroupList()
        let thingMap = ThingMap()
        let model = Model(groupList: groupList, thingMap: thingMap)
        
        model.add(thing: "Poop")
        model.add(thing: "Food")
        
        return model
    }
    
    static func save(model: Model) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(model) {
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "Model")
        }
    }
}
