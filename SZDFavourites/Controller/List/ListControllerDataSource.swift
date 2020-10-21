//
//  ListControllerDataSource.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

protocol ListControllerDataSource: class {
    func numberOfGroups(for listController: ListController) -> Int
    func numberOfThings(for listController: ListController, in group: Int) -> Int
    func dataForThing(for listController: ListController, at thingIndex: Int, in groupIndex: Int) -> ViewDataThing
    func dataForGroupHeader(for listController: ListController, at index: Int) -> ViewDataGroup
}
