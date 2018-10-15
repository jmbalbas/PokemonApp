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
    
    private static let requestCache = NSCache<AnyObject, AnyObject>()
    
    enum EndPoint {
        case getPokemon
        
        var description: String {
            switch self {
            case .getPokemon:
                return "/pokemon/"
            }
        }
    }
    
    /// Obtains a pokemon list.
    /// - Parameters:
    ///   - completionHandler: This contains the responsemodel and the error, if any.
    static func getPokemons(completionHandler: @escaping (PokemonListResponseModel?, Error?) -> ()) -> DataRequest? {
        let url = baseUrl + EndPoint.getPokemon.description
        
        if let cachedResponseModel = getCachedRequest(urlString: url, responseModelType: PokemonListResponseModel.self) {
            completionHandler(cachedResponseModel, nil)
            return nil
        }
        
        return Alamofire.request(url, method: .get, parameters: nil).validate().responseJSON { (response) in
            var result: PokemonListResponseModel?
            let error = response.error
            
            defer { completionHandler(result, error) }
            
            guard response.result.isSuccess else { return }

            if let data = response.data, let pokemonListResponseModel = try? JSONDecoder().decode(PokemonListResponseModel.self, from: data) {
                requestCache.setObject(pokemonListResponseModel as AnyObject, forKey: url as AnyObject)

                result = pokemonListResponseModel
            }
        }
    }
    
    /// Obtains the info of a pokemon.
    /// - Parameters:
    ///   - name: The name of the pokemon.
    ///   - completionHandler: This contains the responsemodel and the error, if any.
    static func getPokemon(withName name: String, completionHandler: @escaping (PokemonResponseModel?, Error?) -> ()) -> DataRequest? {
        let url = baseUrl + EndPoint.getPokemon.description + name
        
        if let cachedResponseModel = getCachedRequest(urlString: url, responseModelType: PokemonResponseModel.self) {
            completionHandler(cachedResponseModel, nil)
            return nil
        }
        
        return Alamofire.request(url, method: .get, parameters: nil).validate().responseJSON { (response) in
            var result: PokemonResponseModel?
            let error = response.error
            
            defer { completionHandler(result, error) }
            
            guard response.result.isSuccess else { return }
            
            if let data = response.data, let pokemonResponseModel = try? JSONDecoder().decode(PokemonResponseModel.self, from: data) {
                requestCache.setObject(pokemonResponseModel as AnyObject, forKey: url as AnyObject)
                result = pokemonResponseModel
            }
        }
    }
    
    /// Obtains the info of a pokemon specie.
    /// - Parameters:
    ///   - url: The url to obtain the data from.
    ///   - completionHandler: This contains the responsemodel and the error, if any.
    static func getSpecie(fromURL url: URL, completionHandler: @escaping (PokemonSpecieResponseModel?, Error?) -> ()) -> DataRequest? {
        if let cachedResponseModel = getCachedRequest(urlString: url.absoluteString, responseModelType: PokemonSpecieResponseModel.self) {
            completionHandler(cachedResponseModel, nil)
            return nil
        }
        
        return Alamofire.request(url, method: .get, parameters: nil).validate().responseJSON { (response) in
            var result: PokemonSpecieResponseModel?
            let error = response.error
            
            defer { completionHandler(result, error) }
            
            guard response.result.isSuccess else { return }
            
            if let data = response.data, let pokemonSpecieResponseModel = try? JSONDecoder().decode(PokemonSpecieResponseModel.self, from: data) {
                requestCache.setObject(pokemonSpecieResponseModel as AnyObject, forKey: url.absoluteString as AnyObject)
                result = pokemonSpecieResponseModel
            }
        }
    }
    
    private static func getCachedRequest<T>(urlString: String, responseModelType: T.Type) -> T? where T : Decodable {
        if let responseModel = requestCache.object(forKey: urlString as AnyObject) as? T {
            return responseModel
        }
        
        return nil
    }
    
}
