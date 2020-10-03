//
//  Thing.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//
//  A Thing has a name and an ordered list of items

import Foundation
import UIKit

typealias ThingName = String

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
    
    /// remove item at index
    func removeItem(at index: Int) {
        self.items.remove(at: index)
    }
    
    func indexOfItem(with name: ItemName) -> Int? {
        return self.items.firstIndex{$0.name == name}
    }
    
    func edit(item index: Int, with newName: ItemName) {
        self.items[index].edit(name: newName)
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
