//
//  ListViewModel.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//
//  Applies all changes to the Favourites list.
//  Keeps a reference to the GroupList

import UIKit

class ListViewModel {

    let model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    // MARK: Group
    
    func groupCount() -> Int {
        return self.model.groupCount()
    }
    
    func group(at index: Int) -> Group? {
        return self.model.group(at: index)
    }
    
    func add(group name: GroupName) {
        self.model.add(group: name)
        self.save()
    }
    
    func remove(group: GroupName) {
        self.model.remove(group: group)
        self.save()
    }
    
    func remove(group index: Int) {
        self.model.remove(group: index)
        self.save()
    }
    
    func edit(group name: GroupName, with newName: GroupName) {
        self.model.edit(group: name, with: newName)
        self.save()
    }
    
    // MARK: Thing
    
    func thingCount(group: Int) -> Int {
        return self.model.thingCount(in: group)
    }
    
    func thing(at index: ThingIndex) -> Thing? {
        return self.model.thing(at: index)
    }
    
    func add(thing: Thing) {
        self.model.add(thing: thing)
        self.save()
    }
    
    func remove(thing: Thing) {
        self.model.remove(thing: thing.name)
        self.save()
    }

    func edit(thing: Thing, with name: ThingName, topItemName: String) {
        // FIXME: better edit logic
        // self.model.edit(thing: name, with: itemName)
        let newThing = Thing(name: name)
        newThing.addItem(name: topItemName)
        
        self.model.edit(thing: thing, with: newThing)
        
        self.save()
    }
    
    func move(thing index: ThingIndex, to newIndex: ThingIndex) {
        self.model.move(thing: index, to: newIndex)
        self.save()
    }
    
    // MARK: Item
    
    func add(item name: ItemName, to thing: Thing) {
        self.model.add(item: name, to: thing)
        self.save()
    }
    
    // MARK: Save
    
    private func save() {
        Model.save(model: self.model)
    }
}
