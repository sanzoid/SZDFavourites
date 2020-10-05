//
//  ThingMap.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-28.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

class ThingMap: Codable {
    
    private var things: [ThingName: Thing]
    
    init(things: [ThingName: Thing] = [ThingName: Thing]()) {
        self.things = things
    }
    
    func add(thing name: ThingName) {
        let thing = Thing(name: name)
        self.add(thing: thing)
    }
    
    func add(thing: Thing) {
        // TODO: check it doesn't already exist
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
        // remove and add back with new name
        if let thing = self.remove(thing: name) {
            thing.edit(name: newName)
            self.things[newName] = thing
        }
    }
    
    subscript(name: String) -> Thing? {
        return self.things[name]
    }
}
