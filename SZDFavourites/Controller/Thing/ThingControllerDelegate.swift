//
//  ThingControllerDelegate.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

protocol ThingControllerDelegate: class {
    // thing
    func editThing()
    func removeThing()
    
    // item
    func addItem(name: String)
    func editItem(at index: Int, with newName: String)
    func moveItem(from index: Int, to newIndex: Int)
    func removeItem(at index: Int)
    
    func close()
}
