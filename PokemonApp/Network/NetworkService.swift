//
//  NetworkService.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 12/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkService {
    static var baseUrl = "https://pokeapi.co/api/v2"
    
    enum EndPoint {
        case getPokemon
        
        var description: String {
            switch self {
            case .getPokemon:
                return "/pokemon/"
            }
        }
    }
    
    static func getPokemons(completionHandler: @escaping (PokemonListResponseModel?, Error?) -> ()) {
        Alamofire.request(baseUrl + EndPoint.getPokemon.description, method: .get, parameters: nil).validate().responseJSON { (response) in
            var result: PokemonListResponseModel?
            let error = response.error
            
            defer { completionHandler(result, error) }
            
            guard response.result.isSuccess else { return }

            if let data = response.data, let pokemonListResponseModel = try? JSONDecoder().decode(PokemonListResponseModel.self, from: data) {
                result = pokemonListResponseModel
            }
        }
    }
    
    static func getPokemon(withName name: String, completionHandler: @escaping (PokemonResponseModel?, Error?) -> ()) {
        let url = baseUrl + EndPoint.getPokemon.description + name
        Alamofire.request(url, method: .get, parameters: nil).validate().responseJSON { (response) in
            var result: PokemonResponseModel?
            let error = response.error
            
            defer { completionHandler(result, error) }
            
            guard response.result.isSuccess else { return }
            
            if let data = response.data, let pokemonListResponseModel = try? JSONDecoder().decode(PokemonResponseModel.self, from: data) {
                result = pokemonListResponseModel
            }
        }
    }

}
