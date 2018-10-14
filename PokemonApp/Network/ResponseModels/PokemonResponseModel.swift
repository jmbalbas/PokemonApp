//
//  PokemonResponseModel.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 12/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import Foundation

struct PokemonResponseModel {
    private(set) var name: String?
    private(set) var id: Int?
    private(set) var order: Int?
    private(set) var height: Int?
    private(set) var weight: Int?
    private(set) var baseExperience: Int?
    private(set) var types: [TypesResponseModel]?
    private(set) var sprites: Sprite?
    private(set) var species: SpeciesResponseModel?
}

extension PokemonResponseModel: Decodable {
    
    private enum Keys: String, CodingKey {
        case name, id, order, height, weight, types, sprites, species
        case baseExperience = "base_experience"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let name = try? container.decode(String.self, forKey: Keys.name)
        let id = try? container.decode(Int.self, forKey: Keys.id)
        let order = try? container.decode(Int.self, forKey: Keys.order)
        let height = try? container.decode(Int.self, forKey: Keys.height)
        let weight = try? container.decode(Int.self, forKey: Keys.weight)
        let baseExperience = try? container.decode(Int.self, forKey: Keys.baseExperience)
        let types = try? container.decode([TypesResponseModel].self, forKey: Keys.types)
        let sprites = try? container.decode(Sprite.self, forKey: Keys.sprites)
        let species = try? container.decode(SpeciesResponseModel.self, forKey: Keys.species)

        self.init(name: name, id: id, order: order, height: height, weight: weight, baseExperience: baseExperience, types: types, sprites: sprites, species: species)
    }
}

struct TypesResponseModel {
    let slot: Int?
    let type: TypeResponseModel?
}

extension TypesResponseModel: Decodable {
    private enum Keys: String, CodingKey {
        case slot, type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let slot = try? container.decode(Int.self, forKey: Keys.slot)
        let type = try? container.decode(TypeResponseModel.self, forKey: Keys.type)
        
        self.init(slot: slot, type: type)
    }
}

struct TypeResponseModel {
    let name: String?
    let url: String?
}

extension TypeResponseModel: Decodable {
    private enum Keys: String, CodingKey {
        case name, url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let name = try? container.decode(String.self, forKey: Keys.name)
        let url = try? container.decode(String.self, forKey: Keys.url)
        
        self.init(name: name, url: url)
    }
}

struct Sprite {
    let frontDefault: URL?
    let backDefault: URL?
    let frontFemale: URL?
    let backFemale: URL?
    let frontShiny: URL?
    let backShiny: URL?
    let frontShinyFemale: URL?
    let backShinyFemale: URL?
}

extension Sprite: Decodable {
    
    private enum Keys: String, CodingKey {
        case frontDefault = "front_default"
        case backDefault = "back_default"
        case frontFemale = "front_female"
        case backFemale = "back_female"
        case frontShiny = "front_shiny"
        case backShiny = "back_shiny"
        case frontShinyFemale = "front_shiny_female"
        case backShinyFemale = "back_shiny_female"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let frontDefault = try? container.decode(String.self, forKey: Keys.frontDefault)
        let backDefault = try? container.decode(String.self, forKey: Keys.backDefault)
        let frontFemale = try? container.decode(String.self, forKey: Keys.frontFemale)
        let backFemale = try? container.decode(String.self, forKey: Keys.backFemale)
        let frontShiny = try? container.decode(String.self, forKey: Keys.frontShiny)
        let backShiny = try? container.decode(String.self, forKey: Keys.backShiny)
        let frontShinyFemale = try? container.decode(String.self, forKey: Keys.frontShinyFemale)
        let backShinyFemale = try? container.decode(String.self, forKey: Keys.backShinyFemale)
        
        self.init(frontDefault: URL(string: frontDefault ?? ""),
                  backDefault: URL(string: backDefault ?? ""),
                  frontFemale: URL(string: frontFemale ?? ""),
                  backFemale: URL(string: backFemale ?? ""),
                  frontShiny: URL(string: frontShiny ?? ""),
                  backShiny: URL(string: backShiny ?? ""),
                  frontShinyFemale: URL(string: frontShinyFemale ?? ""),
                  backShinyFemale: URL(string: backShinyFemale ?? ""))
    }
}

struct SpeciesResponseModel {
    private(set) var name: String?
    private(set) var url: URL?
}

extension SpeciesResponseModel: Decodable {
    private enum Keys: String, CodingKey {
        case name, url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let name = try? container.decode(String.self, forKey: Keys.name)
        let urlString = try? container.decode(String.self, forKey: Keys.url)
        
        var url: URL?
        if let urlString = urlString {
            url = URL(string: urlString)
        }
        
        self.init(name: name, url: url)
    }
}
