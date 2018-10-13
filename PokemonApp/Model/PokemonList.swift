//
//  PokemonList.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 12/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import Foundation

struct PokemonList {
    private(set) var pokemonNames: [String]
}

extension PokemonList {
    static func model(fromResponseModel responseModel: PokemonListResponseModel) -> PokemonList {
        return PokemonList(pokemonNames: responseModel.pokemons!.map { return $0.pokemonName })
    }
}
