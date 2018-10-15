//
//  GameEngine.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 14/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import Foundation

class GameEngine {
    let pokemonNames: [String]
    var questions: [Question] = []
    
    init(pokemonNames: [String]) {
        self.pokemonNames = pokemonNames
    }
    
    func getQuestion(completion: @escaping (Question?) -> Void) {
        if !questions.isEmpty {
            completion(questions.popLast()!)
        } else {
            getQuestions(amount: 3) { [weak self] in
                completion(self?.questions.popLast()!)
            }
        }
        
        if questions.count <= 1 {
            getQuestions(amount: 3)
        }
    }
    
    func getQuestions(amount: Int, completion: (() -> Void)? = nil) {
        var questions = [Question]()
        let dispatchGroup = DispatchGroup()
        for _ in 0 ..< amount {
            dispatchGroup.enter()
            getRandomPokemonWithImage { (pokemon) in
                var answers = self.getRandomAnswers(for: pokemon)
                answers.append(pokemon.name)
                answers.shuffle()
                
                questions.append(Question(title: "¿Cual es este Pokemon?", imageURL: pokemon.sprites!.frontDefault!, answers: answers, correctAnswer: pokemon.name))
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
        
        getPokemon(withName: pokemonName) { (pokemon) in
            if !pokemon.hasSprites() {
                self.getRandomPokemonWithImage(completion: completion)
            } else {
                completion(pokemon)
            }
        }
    }
    
    private func getPokemon(withName name: String, completion: @escaping (Pokemon) -> Void) {
        NetworkService.getPokemon(withName: name) { (pokemonResponseModel, error) in
            if let _ = error {
                
            }
            
            if let pokemonResponseModel = pokemonResponseModel, let pokemon = Pokemon.model(fromPokemonResponseModel: pokemonResponseModel, andPokemoSpecieResponseModel: nil) {
                completion(pokemon)
            }
        }
    }
}
