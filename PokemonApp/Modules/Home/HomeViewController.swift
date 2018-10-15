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
    
    private let pokedexButton: UIButton = {
        let pokedexButton = UIButton()
        pokedexButton.translatesAutoresizingMaskIntoConstraints = false
        pokedexButton.setTitle("Pokedex".localized, for: .normal)
        pokedexButton.setTitleColor(UIColor(red: 255/255, green: 203/255, blue: 164/255, alpha: 1), for: .normal)
        pokedexButton.setBackgroundImage(UIImage(color: UIColor(red: 255/255, green: 111/255, blue: 0, alpha: 1)), for: .normal)
        pokedexButton.setBackgroundImage(UIImage(color: UIColor(red: 217/255, green: 94/255, blue: 0, alpha: 1)), for: .highlighted)
        pokedexButton.layer.cornerRadius = 20
        pokedexButton.clipsToBounds = true
        return pokedexButton
    }()
    
    private let playButton: UIButton = {
        let playButton = UIButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("Play".localized, for: .normal)
        playButton.setTitleColor(UIColor(red: 255/255, green: 203/255, blue: 164/255, alpha: 1), for: .normal)
        playButton.setBackgroundImage(UIImage(color: UIColor(red: 255/255, green: 111/255, blue: 0, alpha: 1)), for: .normal)
        playButton.setBackgroundImage(UIImage(color: UIColor(red: 217/255, green: 94/255, blue: 0, alpha: 1)), for: .highlighted)
        playButton.layer.cornerRadius = 20
        playButton.clipsToBounds = true
        return playButton
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 30

        stackView.addArrangedSubview(pokedexButton)
        stackView.addArrangedSubview(playButton)
        
        pokedexButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUILayout()
        setupButtonsActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUILayout() {
        title = "Home".localized

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
    
    private func setupButtonsActions() {
        playButton.addTarget(self, action: #selector(playButtonDidTouchUpInside), for: .touchUpInside)
        pokedexButton.addTarget(self, action: #selector(pokedexButtonDidTouchUpInside), for: .touchUpInside)
    }
    
    @objc private func playButtonDidTouchUpInside() {
        let gameViewController = GameViewController()
        navigationController?.pushViewController(gameViewController, animated: true)
    }
    
    @objc private func pokedexButtonDidTouchUpInside() {
        let pokedexViewController = PokedexViewController()
        navigationController?.pushViewController(pokedexViewController, animated: true)
    }
    
}
