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
    var groups = GroupList()
    
    init() {
        self.groups = self.retrieveList()
    }
    
    // MARK: Persistence
    
    /// retrieve persisted list or default list
    func retrieveList() -> GroupList {
        let defaults = UserDefaults.standard
        
        if let listData = defaults.object(forKey: "List") as? Data {
            let decoder = JSONDecoder()
            if let list = try? decoder.decode(GroupList.self, from: listData) {
                return list
            }
        }
        
        // default list
        let list = GroupList()
        let thing1 = Thing(name: "Animal")
        thing1.addItem(name: "Raccoon")
        list.defaultGroup.add(thing: thing1)
        let thing2 = Thing(name: "Vegetable")
        thing2.addItem(name: "Potato")
        thing2.addItem(name: "Corn")
        list.defaultGroup.add(thing: thing2)
        let thing3 = Thing(name: "Food")
        list.defaultGroup.add(thing: thing3)
        
        return list
    }
    
    /// save list in persisted store
    func saveList() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self.groups) {
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "List")
        }
    }
        
    // MARK: Data
    // add, get, move, edit, delete thing
    // later: add, move, edit, delete group
    
    func thing(at index: ThingIndex) -> Thing {
        return self.groups[index.groupIndex].things[index.thingIndex]
    }
    
    func addThing(_ thing: Thing) {
        self.groups.defaultGroup.add(thing: thing)
        
        self.saveList()
    }
}
