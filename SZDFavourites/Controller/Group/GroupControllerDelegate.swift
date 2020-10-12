//
//  GroupControllerDelegate.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

protocol GroupControllerDelegate: class {
    func selectGroup(at index: Int)
    func addGroup()
    func removeGroup(at index: Int) -> Bool
    func moveGroup(from index: Int, to newIndex: Int)
}
