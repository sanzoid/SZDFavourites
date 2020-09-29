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
    
    func groupCount() -> Int {
        return self.model.groupCount()
    }
    
    func thingCount(group: Int) -> Int {
        return self.model.thingCount(in: group)
    }
    
    init(model: Model) {
        self.model = model
    }
    
    // MARK: Persistence
    
    func saveList() {
        Model.save(model: self.model)
    }
    
    // MARK: Data
    // add, get, move, edit, delete thing
    // later: add, move, edit, delete group
    
    func thing(at index: ThingIndex) -> Thing? {
        return self.model.thing(at: index)
    }
    
    func add(thing: Thing) {
        self.model.add(thing: thing)
        
        self.saveList()
    }
    
    func editThing(_ thing: Thing, name: String, topItemName: String) {
        // FIXME: better edit logic
        let newThing = Thing(name: name)
        newThing.addItem(name: topItemName)
        
        self.model.edit(thing: thing, with: newThing)
        
        self.saveList()
    }
    
    func remove(thing: Thing) {
        self.model.remove(thing: thing.name)
        
        self.saveList()
    }
}
