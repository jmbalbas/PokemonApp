//
//  Pokemon.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 12/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import Foundation

struct Pokemon {
    let name: String
    let id: Int
    let descriptions: [PokemonDescription]?
    let order: Int?
    let height: Int?
    let weight: Int?
    let baseExperience: Int?
    let types: [PokemonType]?
    let sprites: Sprite?
    
    func hasSprites() -> Bool {
        return sprites?.frontDefault != nil
    }
    
    func hasTypes() -> Bool {
        return !(types?.isEmpty == true)
    }
    
    func hasDescription() -> Bool {
        return getLocalizedDescription() != nil
    }
    
    func getLocalizedDescription() -> String? {
        if let language = Locale.preferredLanguages.first {
            let languageDict = Locale.components(fromIdentifier: language)
            let languageCode = languageDict["kCFLocaleLanguageCodeKey"]
            if let languageDescription = descriptions?.filter({ $0.languageCode == languageCode }).first {
                return languageDescription.description
            }
        }
        
        return descriptions?.filter { $0.languageCode == "en" }.first?.description
    }
}

extension Pokemon {
    static func model(fromPokemonResponseModel pokemonResponseModel: PokemonResponseModel, andPokemoSpecieResponseModel pokemonSpecieResponseModel: PokemonSpecieResponseModel?) -> Pokemon? {
        guard let name = pokemonResponseModel.name, let id = pokemonResponseModel.id else { return nil }
        
        var descriptions: [PokemonDescription]?
        if let pokemonSpecieResponseModel = pokemonSpecieResponseModel {
            descriptions = pokemonSpecieResponseModel.description!.compactMap {
                guard let description = $0.description, let languageCode = $0.language?.name else { return nil }
                
                return PokemonDescription(description: description, languageCode: languageCode)
            }
        }

        return Pokemon(name: name,
                       id: id,
                       descriptions: descriptions,
                       order: pokemonResponseModel.order,
                       height: pokemonResponseModel.height,
                       weight: pokemonResponseModel.weight,
                       baseExperience: pokemonResponseModel.baseExperience,
                       types: pokemonResponseModel.types?.compactMap { PokemonType(rawValue: $0.type?.name ?? "") } ,
                       sprites: pokemonResponseModel.sprites)
    }
}

struct PokemonDescription {
    let description: String
    let languageCode: String
}
