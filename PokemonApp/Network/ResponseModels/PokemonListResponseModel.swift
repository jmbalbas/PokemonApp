//
//  PokemonListResponseModel.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 12/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import Foundation

struct PokemonListResponseModel {
    private(set) var count: Int
    private(set) var pokemons: [(pokemonName: String, url: URL?)]?
}

extension PokemonListResponseModel: Decodable {
    
    struct Pokemon: Decodable {
        private(set) var name: String
        private(set) var url: URL?
        
        init(name: String, url: URL?) {
            self.name = name
            self.url = url
        }
        
        private enum Keys: String, CodingKey {
            case name, url
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Keys.self)
            
            let name = try? container.decode(String.self, forKey: Keys.name)
            let urlString = try? container.decode(String.self, forKey: Keys.url)
            
            self.init(name: name ?? "", url: URL(string: urlString ?? ""))
        }
    }
    
    private enum Keys: String, CodingKey {
        case count
        case pokemons = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let count = try? container.decode(Int.self, forKey: Keys.count)
        let pokemons = try? container.decode([Pokemon].self, forKey: Keys.pokemons)
        
        self.init(count: count ?? 0,
                  pokemons: pokemons?.map {
                    return (pokemonName: $0.name, url: $0.url)
            })
    }
    
}
