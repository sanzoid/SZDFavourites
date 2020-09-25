//
//  Thing.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//
//  A Thing has a name and an ordered list of items
//  It keeps a reference to its Group.

import Foundation
import UIKit

class Thing {
    
    weak var group: Group? 
    var name: String
    private var items: [Item]
    
    init(name: String, items: [Item] = [Item]()) {
        self.name = name
        self.items = items
    }
    
    /// add a new item to the end of the list
    func addItem(name: String, image: UIImage? = nil) -> Item? {
        // check if item already exists
        if self.indexOfItem(with: name) != nil {
            return nil
        }
        
        let item = Item(thing: self, name: name, image: image)
        self.items.append(item)
        return item
    }
    
    /// remove item at index
    func removeItem(at index: Int) {
        self.items.remove(at: index)
    }
    
    func indexOfItem(with name: String) -> Int? {
        return self.items.firstIndex{$0.name == name}
    }
}
