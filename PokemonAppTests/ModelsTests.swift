//
//  ModelsTests.swift
//  PokemonAppTests
//
//  Created by Juan Santiago Martín Balbás on 15/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import XCTest
@testable import PokemonApp

class ModelsTests: XCTestCase {

    func testPokemonListResponseModel() {
        let json = """
            {
              "count": 3,
              "next": null,
              "previous": null,
              "results": [
                {
                  "name": "bulbasaur",
                  "url": "https://pokeapi.co/api/v2/pokemon/1/"
                },
                {
                  "name": "ivysaur",
                  "url": "https://pokeapi.co/api/v2/pokemon/2/"
                },
                {
                  "name": "venusaur",
                  "url": "https://pokeapi.co/api/v2/pokemon/3/"
                }
              ]
            }
            """
        
        guard let data = json.data(using: .utf8) else {
            XCTFail("Invalid data")
            return
        }
        
        guard let pokemonListResponseModel = try? JSONDecoder().decode(PokemonListResponseModel.self, from: data) else {
            XCTFail("Invalid parsing of data")
            return
        }
        
        XCTAssertEqual(pokemonListResponseModel.count, 3)
        XCTAssertEqual(pokemonListResponseModel.pokemons?.count, 3)
        
        
        let pokemonNames = ["bulbasaur", "ivysaur", "venusaur"]
        let pokemonURLs = ["https://pokeapi.co/api/v2/pokemon/1/", "https://pokeapi.co/api/v2/pokemon/2/", "https://pokeapi.co/api/v2/pokemon/3/"]
        
        guard let pokemons = pokemonListResponseModel.pokemons else {
            XCTFail()
            return
        }
        for (index, pokemon) in pokemons.enumerated() {
            XCTAssertEqual(pokemon.pokemonName , pokemonNames[index])
            XCTAssertEqual(pokemon.url?.absoluteString , pokemonURLs[index])
        }
    }
    
    func testPokemonList() {
        let pokemonListResponseModel = PokemonListResponseModel(count: 2, pokemons: [("bulbasaur", URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!),
                                                                                     ("ivysaur", URL(string: "https://pokeapi.co/api/v2/pokemon/2/")!)])
        
        guard let pokemonList = PokemonList.model(fromResponseModel: pokemonListResponseModel) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(pokemonList.list.count, 2)
        
        let pokemonIds = ["1", "2"]
        let pokemonNames = ["bulbasaur", "ivysaur"]
        
        for (index, pokemon) in pokemonList.list.enumerated() {
            XCTAssertEqual(pokemon.pokemonId, pokemonIds[index])
            XCTAssertEqual(pokemon.pokemonName, pokemonNames[index])
        }
    }
    
    func testPokemonResponseModel() {
        let json = """
            {
            "abilities": [],
            "base_experience": 64,
            "forms": [],
            "game_indices": [],
            "height": 7,
            "held_items": [],
            "id": 1,
            "is_default": true,
            "location_area_encounters": "https://pokeapi.co/api/v2/pokemon/1/encounters",
            "moves": [],
            "name": "bulbasaur",
            "order": 1,
            "species": {},
            "sprites": {
            "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png",
            "back_female": null,
            "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png",
            "back_shiny_female": null,
            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
            "front_female": null,
            "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png",
            "front_shiny_female": null
            },
            "stats": [],
            "types": [],
            "weight": 69
            }
            """
        
        guard let data = json.data(using: .utf8) else {
            XCTFail("Invalid data")
            return
        }
        
        guard let pokemonResponseModel = try? JSONDecoder().decode(PokemonResponseModel.self, from: data) else {
            XCTFail("Invalid parsing of data")
            return
        }
        
        XCTAssertEqual(pokemonResponseModel.baseExperience, 64)
        XCTAssertEqual(pokemonResponseModel.height, 7)
        XCTAssertEqual(pokemonResponseModel.weight, 69)
        XCTAssertEqual(pokemonResponseModel.id, 1)
        XCTAssertEqual(pokemonResponseModel.order, 1)
        XCTAssertEqual(pokemonResponseModel.name, "bulbasaur")
        XCTAssertEqual(pokemonResponseModel.baseExperience, 64)
        XCTAssertEqual(pokemonResponseModel.types?.count, 0)
        XCTAssertEqual(pokemonResponseModel.sprites?.frontDefault?.absoluteString, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
        XCTAssertEqual(pokemonResponseModel.sprites?.backDefault?.absoluteString, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")
        XCTAssertEqual(pokemonResponseModel.sprites?.frontShiny?.absoluteString, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png")
        XCTAssertEqual(pokemonResponseModel.sprites?.backShiny?.absoluteString, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png")
    }
    
    func testSpeciesResponseModel() {
        let json = """
            {
            "base_happiness": 70,
            "capture_rate": 45,
            "color": {},
            "egg_groups": [],
            "evolution_chain": {},
            "evolves_from_species": null,
            "flavor_text_entries": [
            {
            "flavor_text": "Bulbasaur can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun’s rays, the seed grows progressively larger.",
            "language": {
            "name": "en",
            "url": "https://pokeapi.co/api/v2/language/9/"
            },
            "version": {
            "name": "alpha-sapphire",
            "url": "https://pokeapi.co/api/v2/version/26/"
            }
            },
            {
            "flavor_text": "A Bulbasaur es fácil verle echándose una siesta al sol. La semilla que tiene en el lomo va creciendo cada vez más a medida que absorbe los rayos del sol.",
            "language": {
            "name": "es",
            "url": "https://pokeapi.co/api/v2/language/7/"
            },
            "version": {
            "name": "alpha-sapphire",
            "url": "https://pokeapi.co/api/v2/version/26/"
            }
            }
            ],
            "form_descriptions": [],
            "forms_switchable": false,
            "gender_rate": 1,
            "genera": [],
            "generation": {},
            "growth_rate": {},
            "habitat": {},
            "has_gender_differences": false,
            "hatch_counter": 20,
            "id": 1,
            "is_baby": false,
            "name": "bulbasaur",
            "names": [],
            "order": 1,
            "pal_park_encounters": [],
            "pokedex_numbers": [],
            "shape": {},
            "varieties": []
            }
            """
        
        guard let data = json.data(using: .utf8) else {
            XCTFail("Invalid data")
            return
        }
        
        guard let pokemonSpecieResponseModel = try? JSONDecoder().decode(PokemonSpecieResponseModel.self, from: data) else {
            XCTFail("Invalid parsing of data")
            return
        }
        
        XCTAssertEqual(pokemonSpecieResponseModel.description?.count, 2)
        XCTAssertEqual(pokemonSpecieResponseModel.description?.first?.description, "Bulbasaur can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun’s rays, the seed grows progressively larger.")
        XCTAssertEqual(pokemonSpecieResponseModel.description?.first?.language?.name, "en")
        XCTAssertEqual(pokemonSpecieResponseModel.description?.last?.description, "A Bulbasaur es fácil verle echándose una siesta al sol. La semilla que tiene en el lomo va creciendo cada vez más a medida que absorbe los rayos del sol.")
        XCTAssertEqual(pokemonSpecieResponseModel.description?.last?.language?.name, "es")
    }
    
    func testPokemon() {
        let sprite = Sprite(frontDefault: URL(string: "https://www.pokeapi.co"), backDefault: nil, frontFemale: nil, backFemale: nil, frontShiny: nil, backShiny: nil, frontShinyFemale: nil, backShinyFemale: nil)
        let pokemonResponseModel = PokemonResponseModel(name: "bulbasaur", id: 1, order: 1, height: 7, weight: 69, baseExperience: 64, types: [TypesResponseModel(slot: nil, type: TypeResponseModel(name: "grass", url: nil))], sprites: sprite, species: nil)
        let pokemonDescriptionResponseModelES = PokemonDescriptionResponseModel(description: "Texto en español", language: LanguageResponseModel(name: "es", url: nil))
        let pokemonDescriptionResponseModelEN = PokemonDescriptionResponseModel(description: "English text", language: LanguageResponseModel(name: "en", url: nil))
        let specieResponseModel = PokemonSpecieResponseModel(description: [pokemonDescriptionResponseModelES, pokemonDescriptionResponseModelEN])
        
        guard let pokemon = Pokemon.model(fromPokemonResponseModel: pokemonResponseModel, andPokemoSpecieResponseModel: specieResponseModel) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(pokemon.baseExperience, 64)
        XCTAssertEqual(pokemon.height, 7)
        XCTAssertEqual(pokemon.weight, 69)
        XCTAssertEqual(pokemon.id, 1)
        XCTAssertEqual(pokemon.order, 1)
        XCTAssertEqual(pokemon.name, "bulbasaur")
        XCTAssertEqual(pokemon.types?.first!.rawValue, "grass")
        XCTAssertEqual(pokemon.types?.first!.getRGBColorCode()?.red, 139)
        XCTAssertEqual(pokemon.types?.first!.getRGBColorCode()?.green, 201)
        XCTAssertEqual(pokemon.types?.first!.getRGBColorCode()?.blue, 201)

        XCTAssertTrue(pokemon.hasSprites())
        XCTAssertTrue(pokemon.hasTypes())
        XCTAssertTrue(pokemon.hasDescription())
    }

}
