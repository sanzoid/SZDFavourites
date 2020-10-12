//
//  GroupControllerDataSource.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

protocol GroupControllerDataSource: class {
    func numberOfGroups() -> Int
    func dataForGroup(at index: Int) -> DataGroup
}
