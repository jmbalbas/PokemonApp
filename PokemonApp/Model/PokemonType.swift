//
//  File.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 13/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import Foundation

enum PokemonType: String {
    case normal
    case fire
    case water
    case electric
    case grass
    case ice
    case fighting
    case poison
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
    case dragon
    case dark
    case steel
    case fairy
    case unknown
    
    func getRGBColorCode() -> (red: Int, green: Int, blue: Int)? {
        switch self {
        case .normal:
            return (red: 170, green: 170, blue: 155)
        case .fire:
            return (red: 236, green: 84, blue: 53)
        case .water:
            return (red: 78, green: 153, blue: 247)
        case .electric:
            return (red: 248, green: 205, blue: 85)
        case .grass:
            return (red: 139, green: 201, blue: 201)
        case .ice:
            return (red: 126, green: 203, blue: 250)
        case .fighting:
            return (red: 175, green: 91, blue: 74)
        case .poison:
            return (red: 159, green: 91, blue: 150)
        case .ground:
            return (red: 216, green: 187, blue: 101)
        case .flying:
            return (red: 128, green: 155, blue: 248)
        case .psychic:
            return (red: 237, green: 99, blue: 52)
        case .bug:
            return (red: 174, green: 185, blue: 68)
        case .rock:
            return (red: 185, green: 170, blue: 111)
        case .ghost:
            return (red: 101, green: 104, blue: 81)
        case .dragon:
            return (red: 114, green: 106, blue: 230)
        case .dark:
            return (red: 114, green: 86, blue: 71)
        case .steel:
            return (red: 170, green: 170, blue: 186)
        case .fairy:
            return (red: 226, green: 158, blue: 233)
        case .unknown:
            return nil
        }
    }
}
