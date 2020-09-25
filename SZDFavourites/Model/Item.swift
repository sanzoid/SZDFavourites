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

class Item: Codable {
    
    var name: String
//    var image: UIImage?
    
    init(name: String, image: UIImage? = nil) {
        self.name = name
//        self.image = image
    }
}
