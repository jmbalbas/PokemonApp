//
//  PokemonDetailViewController.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 12/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import UIKit
import Alamofire

class PokemonDetailViewController: BaseViewController {
    private var pokemonName: String
    private var pokemonId: String?
    private var pokemonResponseModel: PokemonResponseModel?
    private var pokemonSpecieResponseModel: PokemonSpecieResponseModel?
    private var pokemon: Pokemon? {
        didSet {
            setupTableViewSections()
            tableView.reloadData()
        }
    }
    
    enum Section {
        case description, sprites, type
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
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    init(pokemonName: String, pokemonId: String?) {
        self.pokemonName = pokemonName
        self.pokemonId = pokemonId
        super.init(nibName: nil, bundle:  nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUILayout()
        registerCells()
        loadPokemonData()
    }
    
    private func registerCells() {
        tableView.register(PokemonDetailDescriptionTableViewCell.self, forCellReuseIdentifier: PokemonDetailDescriptionTableViewCell.reuseIdentifier)
        tableView.register(PokemonDetailSpritesTableViewCell.self, forCellReuseIdentifier: PokemonDetailSpritesTableViewCell.reuseIdentifier)
        tableView.register(PokemonDetailTypesTableViewCell.self, forCellReuseIdentifier: PokemonDetailTypesTableViewCell.reuseIdentifier)
    }
    
    private func loadPokemonData() {
        startLoading()
        
        let pokemonRequest = NetworkService.getPokemon(withName: pokemonName) { [weak self] (pokemonResponseModel, error) in
            if let _ = error {
                self?.handleError()
                return
            }

            if let pokemonResponseModel = pokemonResponseModel {
                self?.pokemonResponseModel = pokemonResponseModel

                guard let speciesURL = pokemonResponseModel.species?.url else {
                    self?.pokemon = Pokemon.model(fromPokemonResponseModel: pokemonResponseModel, andPokemonSpecieResponseModel: nil)
                    self?.stopLoading()
                    return
                }

                let pokemonSpecieRequest = NetworkService.getSpecie(fromURL: speciesURL) { (pokemonSpeciesResponseModel, error) in
                    self?.stopLoading()
                    if let _ = error {
                        self?.handleError()
                        return
                    }

                    if let pokemonSpeciesResponseModel = pokemonSpeciesResponseModel {
                        self?.pokemonSpecieResponseModel = pokemonSpeciesResponseModel
                        self?.pokemon = Pokemon.model(fromPokemonResponseModel: pokemonResponseModel, andPokemonSpecieResponseModel: pokemonSpeciesResponseModel)
                    }
                }
                
                self?.requests.append(pokemonSpecieRequest)
            }
        }
        
        requests.append(pokemonRequest)
    }

    private func setupUILayout() {
        navigationItem.largeTitleDisplayMode = .never
        title = pokemonName
        view.backgroundColor = .clear
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupTableViewSections() {
        guard let pokemon = pokemon else { return }
    
        sections.append(.sprites)
        
        if pokemon.hasDescription() {
            sections.append(.description)
        }
        
        sections.append(.type)
    }
}

extension PokemonDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section] {
        case .type:
            return "Types".localized
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
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: PokemonDetailDescriptionTableViewCell.reuseIdentifier, for: indexPath) as! PokemonDetailDescriptionTableViewCell
            if let localizedDescription = pokemon?.getLocalizedDescription() {
                cell.setup(with: localizedDescription)
            }
            return cell
        case .sprites:
            let cell = tableView.dequeueReusableCell(withIdentifier: PokemonDetailSpritesTableViewCell.reuseIdentifier, for: indexPath) as! PokemonDetailSpritesTableViewCell
            cell.setup(with: pokemon?.sprites, defaultFrontImage: UIImage(named: "unknownPokemonFront"), defaultBackImage: UIImage(named: "unknownPokemonBack"))
            return cell
        case .type:
            let cell = tableView.dequeueReusableCell(withIdentifier: PokemonDetailTypesTableViewCell.reuseIdentifier, for: indexPath) as! PokemonDetailTypesTableViewCell
            cell.setup(with: pokemon?.types)
            return cell
        }
    }
    
}

extension PokemonDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section] {
        case .type:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
 
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
}
