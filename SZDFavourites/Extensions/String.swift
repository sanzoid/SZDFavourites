//
//  String.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-24.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

extension String {
    func nonEmpty() -> String? {
        return self.isEmpty ? nil : self
    }
}
