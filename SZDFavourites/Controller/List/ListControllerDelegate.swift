//
//  ListControllerDelegate.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

protocol ListControllerDelegate: class {
    func selectThing(for listController: ListController, at index: ThingIndex)
    func removeThing(for listController: ListController, at index: ThingIndex)
    func moveThing(for listController: ListController, from index: ThingIndex, to newIndex: ThingIndex)
}
