//
//  PokedexTableViewCell.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 14/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import UIKit

class PokedexTableViewCell: UITableViewCell {
    static let reuseIdentifier = "PokedexTableViewCellId"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setup(position: Int, name: String) {
        setupUILayout()
        nameLabel.text = String(describing: position) + ". " + name
    }
    
    private func setupUILayout() {
        addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
}
