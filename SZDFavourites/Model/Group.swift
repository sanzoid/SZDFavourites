//
//  Group.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//
//  A Group has a name and an ordered list of Things

import Foundation

class Group: Codable {
    
    var name: String
    var things = [Thing]()
    
    var count: Int {
        return things.count
    }
    
    init(name: String, things: [Thing] = [Thing]()) {
        self.name = name
        self.things = things
    }
    
    func add(thing: Thing) {
        self.things.append(thing)
    }
    
    func remove(thing: Thing) -> Bool {
        if let index = self.index(of: thing) {
            self.things.remove(at: index)
            return true
        }
        
        return false 
    }
    
    func index(of thing: Thing) -> Int? {
        return self.things.firstIndex{$0 == thing}
    }
}
