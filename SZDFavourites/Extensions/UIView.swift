//
//  UIView.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-11-04.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

extension UIView {
    func showTestOutline() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.random.cgColor
    }
}
