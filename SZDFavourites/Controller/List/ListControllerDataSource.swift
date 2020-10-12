//
//  ListControllerDataSource.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

protocol ListControllerDataSource: class {
    func numberOfGroups() -> Int
    func numberOfThings(in group: Int) -> Int
    func dataForThing(at thingIndex: Int, in groupIndex: Int) -> DataListThing
    func dataForGroup(at index: Int) -> DataListGroup
}
