//
//  Rank.swift
//  Project_Ios
//
//  Created by iosadmin on 23.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

enum Badge: String {
    case mercury = "Mercury"
    case mars = "Mars"
    case venus = "Venus"
    case earth = "Earth"
    case neptune = "Neptune"
    case uranus = "Uranus"
    case saturn = "Saturn"
    case jupiter = "Jupiter"
    
    var description: String {
        return self.rawValue
    }
    
    init(badge: String) {
        switch badge {
        case "Mercury":
            self = .mercury
        case "Mars":
            self = .mars
        case "Venus":
            self = .venus
        case "Earth":
            self = .earth
        case "Neptune":
            self = .neptune
        case "Uranus":
            self = .uranus
        case "Saturn":
            self = .saturn
        case "Jupiter":
            self = .jupiter
        default:
            self = .mercury
        }
    }
}

