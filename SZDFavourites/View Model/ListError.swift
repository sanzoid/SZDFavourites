//
//  ListError.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-21.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

enum ListError {
    
    case groupExists
    case thingExists
    case itemExists
    case isDefault
    
    // name character limit
    case groupNameCharMax
    case thingNameCharMax
    case itemNameCharMax
    // name must not be empty
    case groupNameCharMin
    case thingNameCharMin
    case itemNameCharMin
    
    /// reached max number of groups
    case groupMax
    /// reached max number of things
    case thingMax
    /// reached item max for thing
    case itemMax
    
    func message() -> String {
        switch self {
        case .groupExists:
            return "Group already exists."
        case .thingExists:
            return "Thing already exists."
        case .itemExists:
            return "Item already exists."
        case .groupNameCharMax, .thingNameCharMax, .itemNameCharMax:
            return "Name is too long."
        case .groupNameCharMin, .thingNameCharMin, .itemNameCharMin:
            return "Name is required."
        case .isDefault:
            return "Default group cannot be modified."
        default:
            return "An error has occurred."
        }
    }
}
