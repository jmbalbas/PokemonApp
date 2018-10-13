//
//  Pokemon.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 12/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import Foundation

struct Pokemon {
    private(set) var name: String
    private(set) var id: Int
    private(set) var order: Int?
    private(set) var height: Int?
    private(set) var weight: Int?
    private(set) var baseExperience: Int?
    private(set) var types: [String]?
    private(set) var sprites: Sprite?
    
    func hasSprites() -> Bool {
        return sprites?.frontDefault != nil
            || sprites?.backDefault != nil
        // TODO: Complete
    }
    
    func hasTypes() -> Bool {
        return !(types?.isEmpty == true)
    }
}

extension Pokemon {
    static func model(fromResponseModel responseModel: PokemonResponseModel) -> Pokemon? {
        guard let name = responseModel.name, let id = responseModel.id else { return nil }

        return Pokemon(name: name,
                       id: id,
                       order: responseModel.order,
                       height: responseModel.height,
                       weight: responseModel.weight,
                       baseExperience: responseModel.baseExperience,
                       types: responseModel.types?.compactMap {$0.type?.name} ,
                       sprites: responseModel.sprites)
    }
}
