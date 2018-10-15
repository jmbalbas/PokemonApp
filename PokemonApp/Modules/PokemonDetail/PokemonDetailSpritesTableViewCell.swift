//
//  PokemonDetailSpritesTableViewCell.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 14/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import UIKit

class PokemonDetailSpritesTableViewCell: UITableViewCell {
    static let reuseIdentifier = "PokemonDetailSpritesTableViewCellId"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let frontDefaultImageView: BaseImageView = {
        let imageView = BaseImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let backDefaultImageView: BaseImageView = {
        let imageView = BaseImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var sprite: Sprite?
    private var defaultFrontImage: UIImage?
    private var defaultBackImage: UIImage?
    
    func setup(with sprite: Sprite?, defaultFrontImage: UIImage?, defaultBackImage: UIImage?) {
        self.sprite = sprite
        self.defaultFrontImage = defaultFrontImage
        self.defaultBackImage = defaultBackImage
        setupUILayout()
    }
    
    private func setupUILayout() {
        addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(frontDefaultImageView)
        
        frontDefaultImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        frontDefaultImageView.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        frontDefaultImageView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
        
        if let frontDefaultURL = sprite?.frontDefault {
            frontDefaultImageView.loadImageUrl(frontDefaultURL, placeholder: nil)
        } else {
            frontDefaultImageView.image = defaultFrontImage
        }
        stackView.addArrangedSubview(backDefaultImageView)
        backDefaultImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        backDefaultImageView.topAnchor.constraint(equalTo: frontDefaultImageView.topAnchor).isActive = true
        backDefaultImageView.centerYAnchor.constraint(equalTo: frontDefaultImageView.centerYAnchor).isActive = true
        
        if let backDefaultURL = sprite?.backDefault {
            backDefaultImageView.loadImageUrl(backDefaultURL, placeholder: nil)
        } else {
            backDefaultImageView.image = defaultBackImage
        }
    }
}
