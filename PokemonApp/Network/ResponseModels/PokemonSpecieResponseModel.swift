//
//  PokemonSpecieResponseModel.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 13/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import Foundation

struct PokemonSpecieResponseModel {
    let description: [PokemonDescriptionResponseModel]?
}

extension PokemonSpecieResponseModel: Decodable {
    private enum Keys: String, CodingKey {
        case description = "flavor_text_entries"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let description = try? container.decode([PokemonDescriptionResponseModel].self, forKey: Keys.description)
        self.init(description: description)
    }
}

struct PokemonDescriptionResponseModel {
    let description: String?
    let language: LanguageResponseModel?
}

extension PokemonDescriptionResponseModel: Decodable {
    private enum Keys: String, CodingKey {
        case description = "flavor_text"
        case language
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let description = try? container.decode(String.self, forKey: Keys.description).replaceNewlinesWithWhitespaces
        let language = try? container.decode(LanguageResponseModel.self, forKey: Keys.language)

        self.init(description: description, language: language)
    }
}

struct LanguageResponseModel {
    let name: String?
    let url: String?
}

extension LanguageResponseModel: Decodable {
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
