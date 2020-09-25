//
//  Group.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//
//  A Group has a name and an ordered list of Things

import Foundation

class Group {
    
    var name: String
    var things = [Thing]()
    
    init(name: String, things: [Thing] = [Thing]()) {
        self.name = name
        self.things = things
    }
}
