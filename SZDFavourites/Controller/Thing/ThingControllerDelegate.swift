//
//  ThingControllerDelegate.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

protocol ThingControllerDelegate: class {
    // group
    func moveThing(for thingController: ThingController, from group: String, to newGroup: String)
    // thing
    func editThing(for thingController: ThingController, name: String) -> ErrorMessage?
    func removeThing(for thingController: ThingController)
    // item
    func addItem(for thingController: ThingController, name: String) -> ErrorMessage?
    func editItem(for thingController: ThingController, at index: Int, with newName: String) -> ErrorMessage?
    func moveItem(for thingController: ThingController, from index: Int, to newIndex: Int)
    func removeItem(for thingController: ThingController, at index: Int)
    // close 
    func close(for thingController: ThingController)
}
