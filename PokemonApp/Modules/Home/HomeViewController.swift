//
//  HomeViewController.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 12/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "pokemonLogo")
    
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 30
        
        let pokedexButton = UIButton()
        pokedexButton.translatesAutoresizingMaskIntoConstraints = false
        pokedexButton.setTitle("Pokedex", for: .normal)
        pokedexButton.setTitleColor(.black, for: .normal)
        pokedexButton.backgroundColor = .orange
        pokedexButton.layer.cornerRadius = 20
        
        let playButton = UIButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("Play!", for: .normal)
        playButton.setTitleColor(.black, for: .normal)
        playButton.backgroundColor = .orange
        playButton.layer.cornerRadius = 20

        stackView.addArrangedSubview(pokedexButton)
        stackView.addArrangedSubview(playButton)
        
        pokedexButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUILayout()
    }
    

    private func setupUILayout() {
        view.addSubview(logoImageView)
        
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        logoImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2).isActive = true
        
        view.addSubview(buttonsStackView)
        buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
        buttonsStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        buttonsStackView.widthAnchor.constraint(equalToConstant: 250).isActive = true
    }
    

}
