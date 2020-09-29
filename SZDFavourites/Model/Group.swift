//
//  Group.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//
//  A Group has a name and an ordered list of Things

import Foundation

typealias GroupName = String

class Group: Codable {
    
    var name: String
    var things: [ThingName]
    
    var count: Int {
        return things.count
    }
    
    init(name: String, things: [ThingName] = [ThingName]()) {
        self.name = name
        self.things = things
    }
    
    func add(thing: Thing) {
        self.things.append(thing.name)
    }
    
    func add(thing name: ThingName) {
        self.things.append(name)
    }
    
    func add(things names: [ThingName]) {
        self.things.append(contentsOf: names)
    }
    
    func remove(thing name: ThingName) -> ThingName? {
        if let index = self.indexOf(thing: name) {
            return self.things.remove(at: index)
        }
        
        return nil
    }
    
    func indexOf(thing name: ThingName) -> Int? {
        return self.things.firstIndex{ $0 == name }
    }
}
