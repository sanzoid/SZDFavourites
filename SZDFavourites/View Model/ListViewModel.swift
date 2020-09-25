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
    var groups: GroupList
    
    init() {
        self.groups = GroupList()
        
        // TODO: Temporary
        let thing1 = Thing(name: "Animal")
        thing1.addItem(name: "Raccoon")
        self.groups.defaultGroup.add(thing: thing1)
        let thing2 = Thing(name: "Vegetable")
        thing2.addItem(name: "Potato")
        thing2.addItem(name: "Corn")
        self.groups.defaultGroup.add(thing: thing2)
        let thing3 = Thing(name: "Food")
        self.groups.defaultGroup.add(thing: thing3)
    }
    
    // add, get, move, edit, delete thing
    // later: add, move, edit, delete group
    
    func thing(at index: ThingIndex) -> Thing {
        return self.groups[index.groupIndex].things[index.thingIndex]
    }
}
