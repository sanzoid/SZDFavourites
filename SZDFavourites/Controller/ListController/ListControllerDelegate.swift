//
//  ListControllerDelegate.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

protocol ListControllerDelegate: class {
    func move(from index: ThingIndex, to newIndex: ThingIndex)
    func selectThing(at index: ThingIndex)
    func addThing()
    func removeThing(at index: ThingIndex)
}
