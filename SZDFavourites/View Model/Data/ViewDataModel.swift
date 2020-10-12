//
//  ViewDataModel.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation
import UIKit

struct ViewDataGroup {
    var name: String
}

struct ViewDataThing {
    var name: String
    var topItemName: String?
    var topItemImage: UIImage?
}

struct ViewDataItem {
    var name: String
    var image: UIImage?
}
