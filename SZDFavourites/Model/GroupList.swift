//
//  GroupList.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//
//  A GroupList is an abstraction of a list of Groups.

import UIKit

typealias ThingIndex = (groupIndex: Int, thingIndex: Int)

class GroupList {
    var groups: [Group]
    
    var count: Int {
        return self.groups.count
    }
    
    var defaultGroup: Group {
        return self.groups.first!
    }
    
    init() {
        self.groups = [Group]()
        
        let defaultGroup = Group(name: "Default")
        self.groups.append(defaultGroup)
    }
    
    subscript(index: Int) -> Group {
        return self.groups[index]
    }
}
