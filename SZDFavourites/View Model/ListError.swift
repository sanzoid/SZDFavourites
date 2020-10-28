//
//  ListError.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-21.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

enum ListError {
    
    case groupExists(name: String) // TODO: lowercase to check 
    case thingExists(name: String)
    case itemExists(name: String)
    case isDefault
    
    // name character restrictions
    case groupNameCharMax(value: Int)
    case thingNameCharMax(value: Int)
    case itemNameCharMax(value: Int)
    case groupNameCharMin(value: Int)
    case thingNameCharMin(value: Int)
    case itemNameCharMin(value: Int)
    
    /// reached max number of groups
    case groupMax(value: Int)
    /// reached max number of things
    case thingMax(value: Int)
    /// reached item max for thing
    case itemMax(value: Int)
    
    var title: String? {
        switch self {
        case .groupExists, .thingExists, .itemExists,
             .groupNameCharMax, .thingNameCharMax, .itemNameCharMax,
             .groupNameCharMin, .thingNameCharMin, .itemNameCharMin:
            return "Invalid Input"
        default:
            return "Error"
        }
    }
    
    var message: String? {
        switch self {
        case .groupExists(let name),
             .thingExists(let name),
             .itemExists(let name):
            return "\"\(name)\" already exists."
        case .groupNameCharMax(let max),
             .thingNameCharMax(let max),
             .itemNameCharMax(let max):
            return "Name cannot be longer than \(max)."
        case .groupNameCharMin(let min),
             .thingNameCharMin(let min),
             .itemNameCharMin(let min):
            return "Name cannot be shorter than \(min)."
        case .isDefault:
            return "Default group cannot be modified."
        default:
            return nil
        }
    }
}
