//
//  UIViewController.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-27.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

extension UIViewController {
    func top() -> UIViewController {
        var topController = self
        while let controller = self.presentedViewController {
            topController = controller
        }
        return topController
    }
}
