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
    // TODO: Do validations here
    //  Item - 100 char limit, non-empty 
    
    let model: Model
    
    var selectedThing: Thing? 
    
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
    
    func thing(at index: ThingIndex) -> Thing {
        return self.model.thing(at: index)
    }
    
    func add(thing: Thing) {
        // TODO: return error 
        self.model.add(thing: thing)
        self.save()
    }
    
    func remove(thing: Thing) {
        self.model.remove(thing: thing.name)
        self.save()
    }

    func edit(thing name: ThingName, with newName: ThingName) {
        self.model.edit(thing: name, with: newName)
        self.save()
    }
    
    func move(thing index: ThingIndex, to newIndex: ThingIndex) {
        self.model.move(thing: index, to: newIndex)
        self.save()
    }
    
    // MARK: Item
    
    func add(item name: ItemName, to thing: ThingName) {
        self.model.add(item: name, to: thing)
        self.save()
    }
    
    func edit(item index: Int, for thing: ThingName, with newName: ItemName) {
        // TODO: return error
        self.model.edit(item: index, for: thing, with: newName)
        self.save()
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
    
    // MARK: Save
    
    private func save() {
        Model.save(model: self.model)
    }
}
