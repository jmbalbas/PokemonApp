//
//  PokemonDetailViewController.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 12/10/2018.
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
    
    let frontDefaultImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let backDefaultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var sprite: Sprite?
    
    func setup(sprite: Sprite?) {
        self.sprite = sprite
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
        
        frontDefaultImageView.loadImageUrl(sprite?.frontDefault, placeholder: UIImage())
        
        stackView.addArrangedSubview(backDefaultImageView)
        backDefaultImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        backDefaultImageView.topAnchor.constraint(equalTo: frontDefaultImageView.topAnchor).isActive = true
        backDefaultImageView.centerYAnchor.constraint(equalTo: frontDefaultImageView.centerYAnchor).isActive = true
        
        backDefaultImageView.loadImageUrl(sprite?.backDefault, placeholder: UIImage())
    }
}

class PokemonDetailViewController: BaseViewController {
    private var pokemonName: String
    private var pokemon: Pokemon? {
        didSet {
            setupTableViewSections()
            tableView.reloadData()
        }
    }
    
    enum Section {
        case sprites, type, technicalData
    }
    
    private var sections: [Section] = []
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.estimatedRowHeight = 100;
        return tableView
    }()
    
    init(pokemonName: String) {
        self.pokemonName = pokemonName
        super.init(nibName: nil, bundle:  nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        setupUILayout()
        registerCells()
        loadPokemonData()
    }
    
    private func registerCells() {
        tableView.register(PokemonDetailSpritesTableViewCell.self, forCellReuseIdentifier: PokemonDetailSpritesTableViewCell.reuseIdentifier)
    }
    
    private func loadPokemonData() {
        // TODO: Start loading
        NetworkService.getPokemon(withName: pokemonName) { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            
            // TODO: Stop loading
            if let error = error {
                //TODO: Handle error
                
                return
            }
            
            if let result = result, let pokemon = Pokemon.model(fromResponseModel: result) {
                self?.pokemon = pokemon
            } else {
                // There was a problem when parsing the data. Show alert and dismiss view controller.
            }

        }
    }

    private func setupUILayout() {
        title = pokemonName
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupTableViewSections() {
        guard let pokemon = pokemon else { return }
        
        if pokemon.hasSprites() {
            sections.append(.sprites)
        }
        
//        sections.append(.type)
//        sections.append(.technicalData)
    }
}

extension PokemonDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section] {
        case .sprites:
            return "Sprites"
        default:
            break
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .sprites:
            let cell = tableView.dequeueReusableCell(withIdentifier: PokemonDetailSpritesTableViewCell.reuseIdentifier, for: indexPath) as! PokemonDetailSpritesTableViewCell
            cell.setup(sprite: pokemon?.sprites)
            return cell
        default:
            break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
        
        return cell
    }
    
}

extension PokemonDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
 
}
