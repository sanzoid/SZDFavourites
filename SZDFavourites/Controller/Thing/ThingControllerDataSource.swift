//
//  ThingControllerDataSource.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

protocol ThingControllerDataSource: class {
    var numberOfItems: Int { get }
    func numberOfGroups(for thingController: ThingController) -> Int
    func group(for thingController: ThingController) -> Int
    func dataForGroup(for thingController: ThingController, at index: Int) -> ViewDataGroup
    func dataForThing() -> ViewDataThing
    func dataForItem(at index: Int) -> ViewDataItem
}
