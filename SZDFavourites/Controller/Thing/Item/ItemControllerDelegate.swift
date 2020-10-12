//
//  ItemControllerDelegate.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

protocol ItemControllerDelegate: class {
    func addItem()
    func editItem(index: Int)
    func removeItem(at index: Int)
    func moveItem(from index: Int, to newIndex: Int)
}
