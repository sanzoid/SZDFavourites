//
//  Item.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//
//  An Item has a name and an optional image.

import Foundation
import UIKit

typealias ItemName = String

class Item: Codable {
    
    private(set) var name: ItemName
//    var image: UIImage?
    
    init(name: ItemName, image: UIImage? = nil) {
        self.name = name
//        self.image = image
    }
}

extension Item: Equatable {
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name
    }
}
