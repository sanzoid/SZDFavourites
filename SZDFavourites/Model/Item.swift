//
//  Item.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//
//  An Item has a name and an optional image.
//  It keeps a reference to its Thing as it only exists under it.

import Foundation
import UIKit

class Item {
    
    /// reference to Thing as it only exists under the Thing.
    weak var thing: Thing?
    var name: String
    var image: UIImage?
    
    init(thing: Thing, name: String, image: UIImage? = nil) {
        self.thing = thing
        self.name = name
        self.image = image
    }
}
