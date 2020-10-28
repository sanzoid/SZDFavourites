//
//  Dictionary.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-28.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

extension Dictionary where Key == String {
    subscript(caseInsensitive key: Key) -> Value? {
        get {
            if let k = keys.first(where: { $0.caseInsensitiveCompare(key) ==  .orderedSame }) {
                return self[k]
            }
            return nil
        }
        set {
            if let k = keys.first(where: { $0.caseInsensitiveCompare(key) ==  .orderedSame }) {
                self[k] = newValue
            } else {
                self[key] = newValue
            }
        }
    }
}
