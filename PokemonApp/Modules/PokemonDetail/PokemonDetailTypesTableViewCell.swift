//
//  PokemonDetailTypesTableViewCell.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 14/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import UIKit

class PokemonDetailTypesTableViewCell: UITableViewCell {
    static let reuseIdentifier = "PokemonDetailTypesTableViewCellId"
    
    private var types: [PokemonType] = []
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        return stackView
    }()
    
    func setup(with types: [PokemonType]?) {
        self.types = types ?? [.unknown]
        setupUILayout()
    }
    
    private func setupUILayout() {
        addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        for type in types {
            let typeView = createView(for: type)
            stackView.addArrangedSubview(typeView)
        }
    }
    
    private func createView(for type: PokemonType) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        
        if let colorCode = type.getRGBColorCode() {
            view.backgroundColor = UIColor(red: CGFloat(integerLiteral: colorCode.red) / 255,
                                           green: CGFloat(integerLiteral: colorCode.green) / 255,
                                           blue: CGFloat(integerLiteral: colorCode.blue) / 255,
                                           alpha: 1)
        }
        
        let colorNameLabel = UILabel()
        colorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        colorNameLabel.textColor = .white
        colorNameLabel.text = type.rawValue.localizedUppercase
        
        view.addSubview(colorNameLabel)
        colorNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        colorNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        colorNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        colorNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        colorNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        
        return view
    }
    
}
