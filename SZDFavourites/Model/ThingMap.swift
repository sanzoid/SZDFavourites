//
//  ThingMap.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-28.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

/**
   A **ThingMap** is an unordered map of things. Things are expected to be unique, but the class will not provide feedback if not. It is up to the managing class to provide unique things. 

   - Outside: Methods to manage things, accessors to properties.
   - Inside: Directly manages things and manages each Thing by calling its methods.
*/
final class ThingMap: Codable {
    
    private var things: [ThingName: Thing]
    
    var count: Int {
        return self.things.count
    }
    
    init(things: [ThingName: Thing] = [ThingName: Thing]()) {
        self.things = things
    }
    
    subscript(name: String) -> Thing? {
        return self.things[name]
    }
    
    func exists(name: ThingName) -> Bool {
        return self.things[name] != nil
    }
    
    func add(thing name: ThingName) {
        let thing = Thing(name: name)
        self.add(thing: thing)
    }
    
    func add(thing: Thing) {
        guard !self.exists(name: thing.name) else { return }
        self.things[thing.name] = thing
    }
    
    @discardableResult
    func remove(thing: Thing) -> Thing? {
        return self.remove(thing: thing.name)
    }
    
    @discardableResult
    func remove(thing name: ThingName) -> Thing? {
        return self.things.removeValue(forKey: name)
    }
    
    func edit(thing name: ThingName, with newName: ThingName) {
        guard !self.exists(name: newName) else { return }
        // remove and add back with new name
        if let thing = self.remove(thing: name) {
            thing.edit(name: newName)
            self.things[newName] = thing
        }
    }
}
