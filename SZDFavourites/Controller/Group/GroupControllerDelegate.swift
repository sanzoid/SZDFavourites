//
//  GroupControllerDelegate.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

protocol GroupControllerDelegate: class {
    func selectGroup(for groupController: GroupController, at index: Int)
    func addGroup(for groupController: GroupController)
    func removeGroup(for groupController: GroupController, at index: Int) -> Bool
    func moveGroup(for groupController: GroupController, from index: Int, to newIndex: Int)
}
