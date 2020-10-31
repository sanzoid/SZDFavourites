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
        guard !self.groupExists(name: name, caseSensitive: false) else { return .groupExists }
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
        guard index != newIndex else { return }
        self.groupList.move(group: index, to: newIndex)
    }
    
    func edit(group name: GroupName, with newName: GroupName) -> ModelError? {
        if name == newName { return nil }
        if self.isDefault(group: name) { return .isDefault }
        if let error = self.validateEditGroup(group: name, with: newName) {
            return error
        }
        self.groupList.edit(group: name, with: newName)
        return nil
    }
    
    // MARK: Thing
    
    func thingCount() -> Int {
        return self.thingMap.count
    }
    
    func thingCount(in group: Int) -> Int {
        self.groupList.count(in: group)
    }
    
    func thing(at index: ThingIndex) -> Thing {
        let name = self.groupList.thingName(at: index)
        let thing = self.thingMap.thing(with: name)!
        return thing
    }
    
    func thing(with name: ThingName) -> Thing? {
        return self.thingMap.thing(with: name, caseSensitive: false)
    }
    
    func indexOfThing(name: ThingName) -> ThingIndex? {
        return self.groupList.indexOfThing(name: name, caseSensitive: false)
    }
    
    func add(thing name: ThingName) -> ModelError? {
        guard !self.thingExists(name: name, caseSensitive: false) else { return .thingExists }
        
        self.thingMap.add(thing: name)
        self.groupList.add(thing: name)
        
        return nil
    }
    
    func remove(thing name: ThingName) {
        self.thingMap.remove(thing: name)
        self.groupList.remove(thing: name)
    }
    
    func remove(thing index: ThingIndex) {
        let name = self.thing(at: index).name
        self.remove(thing: name)
    }
    
    func move(thing name: ThingName, from groupName: GroupName, to newGroupName: GroupName) {
        guard groupName != newGroupName else { return }
        self.groupList.move(thing: name, from: groupName, to: newGroupName)
    }
    
    func move(thing index: ThingIndex, to newIndex: ThingIndex) {
        guard index != newIndex else { return }
        self.groupList.move(thing: index, to: newIndex)
    }
    
    func edit(thing name: ThingName, with newName: ThingName) -> ModelError? {
        if name == newName { return nil }
        if let error = self.validateEditThing(thing: name, with: newName) {
            return error
        }
        
        // edit in thingMap
        self.thingMap.edit(thing: name, with: newName)
        
        // edit in groupList
        self.groupList.edit(thing: name, with: newName)
        
        return nil
    }
    
    // MARK: Item
    
    func itemCount(for thing: ThingName) -> Int {
        return self.thingMap.thing(with: thing)!.itemCount()
    }
    
    func item(at index: Int, for thing: ThingName) -> Item {
        return self.thingMap.thing(with: thing)!.item(at: index)
    }
    
    func add(item name: ItemName, to thing: ThingName) -> ModelError? {
        guard !self.itemExists(name: name, for: thing, caseSensitive: false) else { return .itemExists }
        self.thingMap.thing(with: thing)?.addItem(name: name)
        return nil
    }
    
    func remove(item index: Int, for thing: ThingName) {
        self.thingMap.thing(with: thing)?.removeItem(at: index)
    }
    
    func move(item index: Int, for thing: ThingName, to newIndex: Int) {
        guard index != newIndex else { return }
        self.thingMap.thing(with: thing)?.move(item: index, to: newIndex)
    }
    
    func edit(item index: Int, for thing: ThingName, with newName: ItemName) -> ModelError? {
        let name = self.item(at: index, for: thing).name
        if name == newName { return nil }
        if let error = self.validateEditItem(item: name, for: thing, with: newName) {
            return error
        }
        self.thingMap.thing(with: thing)?.edit(item: index, with: newName)
        return nil
    }
    
    func edit(item index: Int, for thing: ThingName, with newImage: UIImage?) {
        if self.item(at: index, for: thing).image == newImage { return }
        self.thingMap.thing(with: thing)?.edit(item: index, with: newImage)
    }
    
    // MARK: Helper
    
    private func validateEditGroup(group name: GroupName, with newName: GroupName) -> ModelError? {
        if name.lowercased() == newName.lowercased() { return nil }
        guard !self.groupExists(name: newName, caseSensitive: false) else { return .groupExists }
        return nil
    }
    
    private func validateEditThing(thing name: ThingName, with newName: ThingName) -> ModelError? {
        if name.lowercased() == newName.lowercased() { return nil }
        if self.thingExists(name: newName, caseSensitive: false) { return .thingExists }
        return nil
    }
    
    private func validateEditItem(item name: ItemName, for thing: ThingName, with newName: ItemName) -> ModelError? {
        if name.lowercased() == newName.lowercased() { return nil }
        if self.itemExists(name: newName, for: thing, caseSensitive: false) { return .itemExists }
        return nil
    }
    
    private func groupExists(name: GroupName, caseSensitive: Bool = true) -> Bool {
        return self.groupList.exists(group: name, caseSensitive: caseSensitive)
    }
    
    private func thingExists(name: ThingName, caseSensitive: Bool = true) -> Bool {
        return self.thingMap.exists(name: name, caseSensitive: caseSensitive) && self.groupList.thingExists(name: name, caseSensitive: caseSensitive)
    }
    
    private func itemExists(name: ItemName, for thing: ThingName, caseSensitive: Bool = true) -> Bool {
        return self.thingMap.thing(with: thing)!.exists(item: name, caseSensitive: caseSensitive)
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
