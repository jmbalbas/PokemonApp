//
//  Array+Extension.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 14/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import Foundation

extension Array {
    func randomElements(number: Int) -> [Element] {
        guard number > 0 else { return [Element]() }
        var remaining = self
        var chosen = [Element]()
        for _ in 0 ..< number {
            guard !remaining.isEmpty else { break }
            let randomIndex = Int(arc4random_uniform(UInt32(remaining.count)))
            chosen.append(remaining[randomIndex])
            remaining.remove(at: randomIndex)
        }
        return chosen
    }
}
