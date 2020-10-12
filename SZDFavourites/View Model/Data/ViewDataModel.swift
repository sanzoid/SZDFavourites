//
//  ViewDataModel.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//
//  Various data models for populating views.

import Foundation
import UIKit

struct ViewDataGroup {
    var name: String
    
    init(group: Group) {
        self.name = group.name
    }
}

struct ViewDataThing {
    var name: String
    var top: ViewDataItem?
    
    init(thing: Thing) {
        self.name = thing.name
        if let topItem = thing.topItem() {
            self.top = ViewDataItem(item: topItem)
        }
    }
}

struct ViewDataItem {
    var name: String
    var image: UIImage?
    
    init(item: Item) {
        self.name = item.name
        self.image = item.image
    }
}
