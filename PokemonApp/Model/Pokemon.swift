//
//  Pokemon.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 12/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import Foundation
struct PokemonDescription {
    private(set) var description: String
    private(set) var languageCode: String
}

struct Pokemon {
    private(set) var name: String
    private(set) var id: Int
    private(set) var descriptions: [PokemonDescription]?
    private(set) var order: Int?
    private(set) var height: Int?
    private(set) var weight: Int?
    private(set) var baseExperience: Int?
    private(set) var types: [PokemonType]?
    private(set) var sprites: Sprite?
    
    func hasSprites() -> Bool {
        return sprites?.frontDefault != nil
            || sprites?.backDefault != nil
        // TODO: Complete
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
            return descriptions?.filter { $0.languageCode == languageCode }.first?.description
        } else {
            return descriptions?.filter { $0.languageCode == "en" }.first?.description
        }
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
