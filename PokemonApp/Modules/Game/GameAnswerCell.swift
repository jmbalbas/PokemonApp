//
//  GameAnswerCell.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 14/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import UIKit

class GameAnswerCell: UITableViewCell {
    
    static let reuseIdentifier = "GameAnswerCellId"
    
    private let defaultBackgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = defaultBackgroundColor
        containerView.layer.cornerRadius = 10
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        return label
    }()
    
    func setup(with description: String) {
        setupUILayout()
        descriptionLabel.text = description
    }
    
    func markAsCorrectAnswer(_ correct: Bool) {
        containerView.backgroundColor = correct ? .green : .red
    }
    
    private func setupUILayout() {
        addSubview(containerView)
        
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        containerView.addSubview(descriptionLabel)
        
        descriptionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 8).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -8).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        containerView.backgroundColor = defaultBackgroundColor
    }
    
}
