//
//  ListError.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-21.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation

enum ListError {
    // already exists
    case groupExists(name: String)
    case thingExists(name: String)
    case itemExists(name: String)
    /// attempt to modify default
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
            
        case .groupMax, .thingMax, .itemMax:
            return "Limit Reached"
            
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
            return "Name cannot be longer than \(max) characters."
            
        case .groupNameCharMin(let min),
             .thingNameCharMin(let min),
             .itemNameCharMin(let min):
            if min <= 1 {
                return "Name cannot be empty."
            } else {
                return "Name must be at least \(min) characters."
            }
            
        case .groupMax(let value),
             .thingMax(let value),
             .itemMax(let value):
            return "Only a maximum of \(value) is allowed."
            
        case .isDefault:
            return "Default group cannot be modified."
            
        default:
            return nil
        }
    }
}
