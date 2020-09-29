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
    
    func remove(thing: Thing) {
        self.remove(thing: thing.name)
    }
    
    func remove(thing name: ThingName) {
        self.things.removeValue(forKey: name)
    }
    
    func edit(thing: Thing, with newThing: Thing, isNewName: Bool) {
        self.things[newThing.name] = newThing
        
        // remove old reference if name changed
        if isNewName {
            self.things[thing.name] = nil
        }
    }
    
    subscript(name: String) -> Thing? {
        return self.things[name]
    }
}
