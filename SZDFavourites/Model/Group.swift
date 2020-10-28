//
//  Group.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

typealias GroupName = String

/**
    A **Group** has a name and an ordered list of Things. Things are expected to be unique, but the class will not provide feedback if not. It is up to the managing class to provide unique things. 
 
    - Outside: Methods to manage name and things, accessors to properties.
    - Inside: Directly manages properties.
 */
final class Group: Codable {
    
    private(set) var name: GroupName
    private(set) var things: [ThingName]
    
    var thingCount: Int {
        return things.count
    }
    
    init(name: String, things: [ThingName] = [ThingName]()) {
        self.name = name
        self.things = things
    }
    
    func edit(name: GroupName) {
        self.name = name
    }
    
    // MARK: Thing
    
    func thing(at index: Int) -> ThingName {
        return self.things[index]
    }
    
    func indexOf(thing name: ThingName, caseSensitive: Bool = true) -> Int? {
        return self.things.firstIndex{
            if caseSensitive {
                return $0 == name
            } else {
                return $0.lowercased() == name.lowercased()
            }
        }
    }
    
    func add(thing name: ThingName) {
        self.things.append(name)
    }
    
    func add(things names: [ThingName]) {
        self.things.append(contentsOf: names)
    }
    
    func insert(thing name: ThingName, at index: Int) {
        self.things.insert(name, at: index)
    }
    
    func remove(thing name: ThingName) -> ThingName? {
        if let index = self.indexOf(thing: name) {
            return self.things.remove(at: index)
        }
        
        return nil
    }
    
    func remove(thing index: Int) -> ThingName? {
        return self.things.remove(at: index)
    }

    func edit(thing index: Int, with newName: ThingName) {
        self.things[index] = newName
    }
}

extension Group: Equatable {
    static func ==(lhs: Group, rhs: Group) -> Bool {
        return lhs.name == rhs.name && lhs.things == rhs.things
    }
}
