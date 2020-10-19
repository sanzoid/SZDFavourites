//
//  ItemControllerDelegate.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

protocol ItemControllerDelegate: class {
    func selectItem(index: Int)
    func addItem()
    func addItem(name: String)
    func removeItem(at index: Int)
    func moveItem(from index: Int, to newIndex: Int)
    func editItem(at index: Int, with newName: String)
}
