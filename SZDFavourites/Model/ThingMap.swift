//
//  ThingMap.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-28.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

/**
   A **ThingMap** is an unordered map of things with case-sensitive names. Things are expected to be unique, but the class will not provide feedback if not - it will just ignore it. It is up to the managing class to provide unique things.
 
   It provides methods for getting case-insensitive things, but the class itself is case-sensitive.

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
    
    func thing(with name: ThingName, caseSensitive: Bool = true) -> Thing? {
        return caseSensitive ? self.things[name] : self.things[caseInsensitive: name]
    }
    
    func exists(name: ThingName, caseSensitive: Bool = true) -> Bool {
        if caseSensitive {
            return self.things[name] != nil
        } else {
            return self.things[caseInsensitive: name] != nil
        }
    }
    
    func add(thing name: ThingName) {
        guard !self.exists(name: name) else { return }
        let thing = Thing(name: name)
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
