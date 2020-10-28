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
   A **Thing** has a name and an ordered list of items. Items are expected to be unique, but the class will not provide feedback if not. It is up to the managing class to provide unique items. 

   - Outside: Methods to manage name and items, accessors to properties.
   - Inside: Directly manages properties.
*/
final class Thing: Codable {
    
    private(set) var name: ThingName
    private(set) var items: [Item]
    
    init(name: ThingName, items: [Item] = [Item]()) {
        self.name = name
        self.items = items
    }
    
    func edit(name newName: ThingName) {
        self.name = newName
    }

    // MARK: Item
    
    func itemCount() -> Int {
        return self.items.count
    }
    
    func item(at index: Int) -> Item {
        return self.items[index]
    }
    
    func indexOfItem(with name: ItemName, caseSensitive: Bool = true) -> Int? {
        return self.items.firstIndex{
            if caseSensitive {
                return $0.name == name
            } else {
                return $0.name.lowercased() == name.lowercased()
            }
        }
    }
    
    func exists(item name: ItemName, caseSensitive: Bool = true) -> Bool {
        return self.indexOfItem(with: name, caseSensitive: caseSensitive) != nil
    }
    
    func addItem(name: ItemName, image: UIImage? = nil) {
        guard !self.exists(item: name) else { return }
        let item = Item(name: name, image: image)
        self.items.append(item)
    }
    
    func insert(item: Item, at index: Int) {
        self.items.insert(item, at: index)
    }
    
    @discardableResult
    func removeItem(at index: Int) -> Item {
        return self.items.remove(at: index)
    }
    
    func move(item index: Int, to newIndex: Int) {
        let item = self.removeItem(at: index)
        self.insert(item: item, at: newIndex)
    }
    
    func edit(item index: Int, with newName: ItemName) {
        guard !self.exists(item: newName) else { return }
        self.items[index].edit(name: newName)
    }
    
    func edit(item index: Int, with newImage: UIImage?) {
        self.items[index].edit(image: newImage)
    }
    
    func topItem() -> Item? {
        guard self.items.count > 0 else {
            return nil
        }
        return self.items[0]
    }
}

extension Thing: Equatable {
    static func ==(lhs: Thing, rhs: Thing) -> Bool {
        return lhs.name == rhs.name && lhs.items == rhs.items
    }
}
