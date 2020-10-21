//
//  ThingControllerDataSource.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

protocol ThingControllerDataSource: class {
    func numberOfItems(for thingController: ThingController) -> Int
    func numberOfGroups(for thingController: ThingController) -> Int
    func group(for thingController: ThingController) -> Int
    func dataForGroup(for thingController: ThingController, at index: Int) -> ViewDataGroup
    func dataForThing(for thingController: ThingController) -> ViewDataThing
    func dataForItem(for thingController: ThingController, at index: Int) -> ViewDataItem
}
