//
//  ItemControllerDataSource.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

protocol ItemControllerDataSource: class {
    var numberOfItems: Int { get }
    func item(at index: Int) -> ViewDataItem
}
