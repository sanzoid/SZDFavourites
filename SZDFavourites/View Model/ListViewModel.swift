//
//  ListViewModel.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

/**
   The **ListViewModel** is the main view model to manipulate the model. It should be the only one making Model calls.

   - Outside: Pass in the Model and make calls for data and data manipulation.
   - Inside: Make data manipulations by calling Model methods.
*/
class ListViewModel {
    
    let model: Model
    var properties: ListProperties
    var selectedThing: Thing? 
    
    init(model: Model, properties: ListProperties) {
        self.model = model
        self.properties = properties 
    }
    
    // MARK: Group
    
    func groupCount() -> Int {
        return self.model.groupCount()
    }
    
    func group(at index: Int) -> Group {
        return self.model.group(at: index)
    }
    
    func add(group name: GroupName) -> ListError? {
        if let error = self.groupLimitReached() {
            return error
        }
        if let error = self.validateGroup(name: name) {
            return error
        }
        if let error = self.model.add(group: name) {
            return error == .groupExists ? .groupExists(name: name) : nil
        }
        self.save()
        return nil
    }
    
    func remove(group: GroupName) -> ListError? {
        if let error = self.model.remove(group: group) {
            return error == .isDefault ? .isDefault : nil
        }
        self.save()
        return nil
    }
    
    func remove(group index: Int) -> ListError? {
        if let error = self.model.remove(group: index) {
            return error == .isDefault ? .isDefault : nil
        }
        self.save()
        return nil
    }
    
    func move(group index: Int, to newIndex: Int) {
        self.model.move(group: index, to: newIndex)
        self.save()
    }
    
    func edit(group name: GroupName, with newName: GroupName) -> ListError? {
        if let error = self.validateGroup(name: newName) {
            return error
        }
        if let error = self.model.edit(group: name, with: newName) {
            if error == .groupExists {
                return .groupExists(name: newName)
            } else if error == .isDefault {
                return .isDefault
            }
            return nil
        }
        self.save()
        return nil
    }
    
    func edit(group index: Int, with newName: GroupName) -> ListError? {
        let group = self.group(at: index)
        return self.edit(group: group.name, with: newName)
    }
    
    func indexOfThing(name: ThingName) -> ThingIndex? {
        return self.model.indexOfThing(name: name)!
    }
    
    // MARK: Thing
    
    func thingCount() -> Int {
        return self.model.thingCount()
    }
    
    func thingCount(group: Int) -> Int {
        return self.model.thingCount(in: group)
    }
    
    func thing(with name: ThingName) -> Thing? {
        return self.model.thing(with: name)
    }
    
    func thing(at index: ThingIndex) -> Thing {
        return self.model.thing(at: index)
    }
    
    func add(thing name: ThingName) -> ListError? {
        if let error = self.thingLimitReached() {
            return error
        }
        if let error = self.validateThing(name: name) {
            return error
        }
        if let error = self.model.add(thing: name) {
            return error == .thingExists ? .thingExists(name: name) : nil
        }
        self.save()
        return nil
    }
    
    func remove(thing: ThingName) {
        self.model.remove(thing: thing)
        self.save()
    }
    
    func remove(thing index: ThingIndex) {
        self.model.remove(thing: index)
        self.save()
    }

    func edit(thing name: ThingName, with newName: ThingName) -> ListError? {
        if let error = self.validateThing(name: newName) {
            return error
        }
        if let error = self.model.edit(thing: name, with: newName) {
            return error == .thingExists ? .thingExists(name: newName) : nil
        }
        self.save()
        return nil
    }
    
    func move(thing index: ThingIndex, to newIndex: ThingIndex) {
        self.model.move(thing: index, to: newIndex)
        self.save()
    }
    
    func move(thing name: ThingName, from group: GroupName, to newGroup: ThingName) {
        self.model.move(thing: name, from: group, to: newGroup)
        self.save()
    }
    
    // MARK: Item
    
    func itemCount(for thing: ThingName) -> Int {
        return self.model.itemCount(for: thing)
    }
    
    func add(item name: ItemName, to thing: ThingName) -> ListError? {
        if let error = self.itemLimitReached(for: thing) {
            return error
        }
        if let error = self.validateItem(name: name) {
            return error
        }
        if let error = self.model.add(item: name, to: thing) {
            return error == .itemExists ? .itemExists(name: name) : nil
        }
        self.save()
        return nil
    }
    
    func edit(item index: Int, for thing: ThingName, with newName: ItemName) -> ListError? {
        if let error = self.validateItem(name: newName) {
            return error
        }
        if let error = self.model.edit(item: index, for: thing, with: newName) {
            return error == .itemExists ? .itemExists(name: newName) : nil
        }
        self.save()
        return nil
    }
    
    func edit(item index: Int, for thing: ThingName, with newImage: UIImage?) {
        self.model.edit(item: index, for: thing, with: newImage)
        self.save()
    }
    
    func move(item index: Int, for thing: ThingName, to newIndex: Int) {
        self.model.move(item: index, for: thing, to: newIndex)
        self.save()
    }
    
    func remove(item index: Int, for thing: ThingName) {
        self.model.remove(item: index, for: thing)
        self.save()
    }
    
    // MARK: Validation
    
    private func validateGroup(name: String) -> ListError? {
        let min = self.properties.groupNameMin
        guard name.count >= min else { return .groupNameCharMin(value: min) }
        let max = self.properties.groupNameMax
        guard name.count <= max else { return .groupNameCharMax(value: max) }
        return nil
    }
    
    private func validateThing(name: String) -> ListError? {
        let min = self.properties.thingNameMin
        guard name.count >= min else { return .thingNameCharMin(value: min) }
        let max = self.properties.thingNameMax
        guard name.count <= max else { return .thingNameCharMax(value: max) }
        return nil
    }
    
    private func validateItem(name: String) -> ListError? {
        let min = self.properties.itemNameMin
        guard name.count >= min else { return .itemNameCharMin(value: min) }
        let max = self.properties.itemNameMax
        guard name.count <= max else { return .itemNameCharMax(value: max) }
        return nil
    }
    
    private func groupLimitReached() -> ListError? {
        let max = self.properties.groupMax
        return self.groupCount() >= max ? .groupMax(value: max) : nil
    }
    
    private func thingLimitReached() -> ListError? {
        let max = self.properties.thingMax
        return self.thingCount() >= max ? .thingMax(value: max) : nil
    }
    
    private func itemLimitReached(for thing: ThingName) -> ListError? {
        let max = self.properties.itemMax
        return self.itemCount(for: thing) >= max ? .itemMax(value: max) : nil
    }
    
    // MARK: Save
    
    private func save() {
        Model.save(model: self.model)
    }
}
