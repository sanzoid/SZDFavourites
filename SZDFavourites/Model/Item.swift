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

/**
   An **Item** has a name and an optional image.

   - Outside: Methods to manage name and image, accessors to properties.
   - Inside: Directly manages properties. 
*/
final class Item: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case image
    }
    
    private(set) var name: ItemName
    private(set) var image: UIImage?
    
    init(name: ItemName, image: UIImage? = nil) {
        self.name = name
        self.image = image
    }
    
    func edit(name newName: String) {
        self.name = newName
    }
    
    func edit(image newImage: UIImage?) {
        self.image = newImage
    }
    
    // MARK: Codable
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        
        let imageData = try container.decode(Data.self, forKey: .image)
        self.image = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(imageData) as? UIImage
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        
        if let image = self.image {
            let imageData = try NSKeyedArchiver.archivedData(withRootObject: image, requiringSecureCoding: false)
            try container.encode(imageData, forKey: .image)
        }
    }
}

extension Item: Equatable {
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name
    }
}
