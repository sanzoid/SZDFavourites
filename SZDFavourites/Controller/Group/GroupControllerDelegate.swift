//
//  GroupControllerDelegate.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

protocol GroupControllerDelegate: class {
    func addGroup(for groupController: GroupController, name: String)
    func removeGroup(for groupController: GroupController, at index: Int) -> Bool
    func moveGroup(for groupController: GroupController, from index: Int, to newIndex: Int)
    func editGroup(for groupController: GroupController, at index: Int, with name: String)
}
