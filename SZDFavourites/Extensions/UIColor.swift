//
//  UIColor.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-11-04.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(red: CGFloat.random(in: 0...1),
                       green: CGFloat.random(in: 0...1),
                       blue: CGFloat.random(in: 0...1),
                       alpha: 1.0)
    }
}
