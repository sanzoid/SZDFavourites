//
//  Model.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-28.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation
import UIKit

enum ModelError: Error {
    /// Attempt to add group that already exists
    case groupExists
    /// Attempt to add thing that already exists
    case thingExists
    /// Attempt to add item that already exists for a thing
    case itemExists
    /// Attempt to modify default group
    case isDefault
}

/**
    The **Model** is responsible for all data manipulation.
 
    - Outside: Methods to manage groups, things, and items. Groups are a mapping of Things. Things can be managed on their own. Items belong to Things.
    - Inside: Manages a groupList and thingMap by calling their methods. Not responsible for verifying existing values, but is responsible for verifying new values added are unique if required.
 */
final class Model: Codable {
    
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
    
    func group(at index: Int) -> Group {
        return self.groupList.group(at: index)
    }
    
    func add(group name: GroupName) -> ModelError? {
        guard !self.groupExists(name: name) else { return .groupExists }
        self.groupList.add(group: name)
        return nil
    }
    
    func remove(group name: GroupName) -> ModelError? {
        guard !self.isDefault(group: name) else { return .isDefault }
        self.groupList.remove(group: name)
        return nil 
    }
    
    func remove(group index: Int) -> ModelError? {
        guard !self.isDefault(group: index) else { return .isDefault }
        self.groupList.remove(group: index)
        return nil
    }
    
    func move(group index: Int, to newIndex: Int) {
        self.groupList.move(group: index, to: newIndex)
    }
    
    func edit(group name: GroupName, with newName: GroupName) -> ModelError? {
        guard !self.isDefault(group: name) else { return .isDefault }
        guard !self.groupExists(name: newName) else { return .groupExists }
        self.groupList.edit(group: name, with: newName)
        return nil
    }
    
    // MARK: Thing
    
    // TODO: unit tests, may need to add the check in some other tests
    func thingCount() -> Int {
        return self.thingMap.count
    }
    
    func thingCount(in group: Int) -> Int {
        self.groupList.count(in: group)
    }
    
    func thing(at index: ThingIndex) -> Thing {
        let name = self.groupList.thingName(at: index)
        let thing = self.thingMap[name]!
        return thing
    }
    
    // TODO: unit tests
    func indexOfThing(name: ThingName) -> ThingIndex? {
        return self.groupList.indexOfThing(name: name)
    }
    
    func add(thing name: ThingName) -> ModelError? {
        guard !self.thingExists(name: name) else { return .thingExists }
        
        self.thingMap.add(thing: name)
        self.groupList.add(thing: name)
        
        return nil
    }
    
    func remove(thing name: ThingName) {
        self.thingMap.remove(thing: name)
        self.groupList.remove(thing: name)
    }
    
    // TODO: unit test 
    func remove(thing index: ThingIndex) {
        let name = self.thing(at: index).name
        self.remove(thing: name)
    }
    
    func move(thing name: ThingName, from groupName: GroupName, to newGroupName: GroupName) {
        self.groupList.move(thing: name, from: groupName, to: newGroupName)
    }
    
    func move(thing index: ThingIndex, to newIndex: ThingIndex) {
        self.groupList.move(thing: index, to: newIndex)
    }
    
    func edit(thing name: ThingName, with newName: ThingName) -> ModelError? {
        guard !self.thingExists(name: newName) else { return .thingExists }
        
        // edit in thingMap
        self.thingMap.edit(thing: name, with: newName)
        
        // edit in groupList if needed 
        if name != newName{
            self.groupList.edit(thing: name, with: newName)
        }
        
        return nil
    }
    
    // MARK: Item
    
    func itemCount(for thing: ThingName) -> Int {
        return self.thingMap[thing]!.itemCount()
    }
    
    // TODO: unit tests
    func item(at index: Int, for thing: ThingName) -> Item {
        return self.thingMap[thing]!.item(at: index)
    }
    
    func add(item name: ItemName, to thing: ThingName) -> ModelError? {
        guard !self.itemExists(name: name, for: thing) else { return .itemExists }
        self.thingMap[thing]?.addItem(name: name)
        return nil
    }
    
    func remove(item index: Int, for thing: ThingName) {
        self.thingMap[thing]?.removeItem(at: index)
    }
    
    func move(item index: Int, for thing: ThingName, to newIndex: Int) {
        self.thingMap[thing]?.move(item: index, to: newIndex)
    }
    
    func edit(item index: Int, for thing: ThingName, with newName: ItemName) -> ModelError? {
        guard !self.itemExists(name: newName, for: thing) else { return .itemExists }
        self.thingMap[thing]?.edit(item: index, with: newName)
        return nil
    }
    
    func edit(item index: Int, for thing: ThingName, with newImage: UIImage?) {
        self.thingMap[thing]?.edit(item: index, with: newImage)
    }
    
    // MARK: Helper
    
    private func groupExists(name: GroupName) -> Bool {
        return self.groupList.exists(group: name)
    }
    
    private func thingExists(name: ThingName) -> Bool {
        return self.thingMap.exists(name: name) && self.groupList.thingExists(name: name)
    }
    
    private func itemExists(name: ItemName, for thing: ThingName) -> Bool {
        return self.thingMap[thing]!.exists(item: name)
    }
    
    private func isDefault(group name: GroupName) -> Bool {
        return self.groupList.defaultGroup.name == name
    }
    
    private func isDefault(group index: Int) -> Bool {
        return self.groupList.defaultGroupIndex == index
    }
    
    // MARK: Peristence
    // TODO: move this out 
    
    static func retrieve() -> Model {
        let defaults = UserDefaults.standard
        
        if let data = defaults.object(forKey: "Model") as? Data {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(Model.self, from: data)
                return model
            } catch {
                print(error)
            }
        }
        
        // default model
        let groupList = GroupList()
        let thingMap = ThingMap()
        let model = Model(groupList: groupList, thingMap: thingMap)
        
        model.add(thing: "Poop")
        model.add(item: "hard", to: "Poop")
        model.add(item: "soft", to: "Poop")
        model.add(thing: "Food")
        
        Model.save(model: model)
        
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
