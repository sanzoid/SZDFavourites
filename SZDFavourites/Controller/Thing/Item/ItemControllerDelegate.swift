//
//  ItemControllerDelegate.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

protocol ItemControllerDelegate: class {
    func addItem(for itemController: ItemController, name: String)
    func removeItem(for itemController: ItemController, at index: Int)
    func moveItem(for itemController: ItemController, from index: Int, to newIndex: Int)
    func editItem(for itemController: ItemController, at index: Int, with newName: String)
}
