//
//  GameEngine.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 14/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import Foundation
import Alamofire

class GameEngine {
    let pokemonNames: [String]
    var questions: [Question] = []
    var requests = [DataRequest?]()
    init(pokemonNames: [String]) {
        self.pokemonNames = pokemonNames
    }
    
    /// Returns a Question.
    func getQuestion(completion: @escaping (Question?) -> Void) {
        if !questions.isEmpty {
            completion(questions.popLast()!)
        } else {
            getQuestions(amount: 3) { [weak self] in
                completion(self?.questions.popLast()!)
            }
        }
        
        // If there is only one question remaining, start loading next batch.
        if questions.count <= 1 {
            getQuestions(amount: 3)
        }
    }
    
    func cancelRequests() {
        requests.forEach { $0?.cancel() }
    }
    
    private func getQuestions(amount: Int, completion: (() -> Void)? = nil) {
        var questions = [Question]()
        let dispatchGroup = DispatchGroup()
        for _ in 0 ..< amount {
            dispatchGroup.enter()
            getRandomPokemonWithImage { [weak self] (pokemon) in
                guard let strongSelf = self else { return }
                
                var answers = strongSelf.getRandomAnswers(for: pokemon)
                answers.append(pokemon.name)
                answers.shuffle()
                
                questions.append(Question(title: "Which one is this Pokémon?".localized, imageURL: pokemon.sprites!.frontDefault!, answers: answers, correctAnswer: pokemon.name))
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            questions.append(contentsOf: self.questions)
            self.questions = questions
            completion?()
        }
    }
    
    private func getRandomAnswers(for pokemon: Pokemon) -> [String] {
        return pokemonNames.filter {$0 != pokemon.name }.randomElements(number: 3)
    }
    
    private func getRandomPokemonWithImage(completion: @escaping (Pokemon) -> Void) {
        let pokemonName = pokemonNames.randomElement()!
        
        getPokemon(withName: pokemonName) { [weak self] (pokemon, error) in
            guard let pokemon = pokemon else {
                self?.getRandomPokemonWithImage(completion: completion)
                return
            }
            
            if !pokemon.hasSprites() {
                self?.getRandomPokemonWithImage(completion: completion)
            } else {
                completion(pokemon)
            }
        }
    }
    
    private func getPokemon(withName name: String, completion: @escaping (Pokemon?, Error?) -> Void) {
        let request = NetworkService.getPokemon(withName: name) { (pokemonResponseModel, error) in
            var pokemon: Pokemon?
            
            defer { completion(pokemon, error) }
            
            if let pokemonResponseModel = pokemonResponseModel, let pokemonModel = Pokemon.model(fromPokemonResponseModel: pokemonResponseModel, andPokemonSpecieResponseModel: nil) {
                pokemon = pokemonModel
            }
        }
        requests.append(request)
    }
}
