//
//  PokemonList.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 12/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import Foundation

struct PokemonList {
    private(set) var list: [(pokemonName: String, pokemonId: String?)]
}

extension PokemonList {
    static func model(fromResponseModel responseModel: PokemonListResponseModel) -> PokemonList? {
        guard let pokemons = responseModel.pokemons else { return nil }
        return PokemonList(list: pokemons.map { ($0.pokemonName, getPokemonIdFromURL($0.url)) })
    }
    
    private static func getPokemonIdFromURL(_ url: URL?) -> String? {
        guard let regex = try? NSRegularExpression(pattern: "\\/([\\d]+)\\/"), let url = url else { return nil}
        
        let urlString = url.absoluteString
        let results = regex.matches(in: urlString, options: [], range: NSRange(location: 0, length: urlString.count))
        
        if let result = results.last, let substring = urlString.substring(with: result.range(at: 1)) {
            return String(substring)
        }
        
        return nil
    }
}
