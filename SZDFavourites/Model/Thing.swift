//
//  Thing.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation
import UIKit

typealias ThingName = String

/**
   A **Thing** has a name and an ordered list of items.

   - Outside: Methods to manage name and items, accessors to properties.
   - Inside: Directly manages properties.
*/
class Thing: Codable {
    
    private(set) var name: ThingName
    private(set) var items: [Item]
    
    init(name: ThingName, items: [Item] = [Item]()) {
        self.name = name
        self.items = items
    }
    
    func itemCount() -> Int {
        return self.items.count 
    }
    
    func edit(name newName: ThingName) {
        self.name = newName
    }
    
    /// add a new item to the end of the list
    @discardableResult
    func addItem(name: ItemName, image: UIImage? = nil) -> Bool {
        // check if item already exists
        if self.indexOfItem(with: name) != nil {
            return false
        }
        
        let item = Item(name: name, image: image)
        self.items.append(item)
        return true
    }
    
    func insert(item: Item, at index: Int) {
        self.items.insert(item, at: index)
    }
    
    /// remove item at index
    @discardableResult
    func removeItem(at index: Int) -> Item {
        return self.items.remove(at: index)
    }
    
    func indexOfItem(with name: ItemName) -> Int? {
        return self.items.firstIndex{$0.name == name}
    }
    
    func edit(item index: Int, with newName: ItemName) {
        self.items[index].edit(name: newName)
    }
    
    func edit(item index: Int, with newImage: UIImage?) {
        self.items[index].edit(image: newImage)
    }
    
    func move(item index: Int, to newIndex: Int) {
        let item = self.removeItem(at: index)
        self.insert(item: item, at: newIndex)
    }
    
    func topItem() -> Item? {
        guard self.items.count > 0 else {
            return nil
        }
        return self.items[0]
    }
    
    subscript(index: Int) -> Item {
        return self.items[index]
    }
}

extension Thing: Equatable {
    static func ==(lhs: Thing, rhs: Thing) -> Bool {
        return lhs.name == rhs.name && lhs.items == rhs.items
    }
}
