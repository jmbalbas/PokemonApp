//
//  GameViewController.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 14/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import UIKit

class GameViewController: BaseViewController {
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    private let imageView: BaseImageView = {
        let imageView = BaseImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.isScrollEnabled = false
        tableView.estimatedRowHeight = 100;
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private var gameEngine: GameEngine?
    private var currentQuestion: Question? {
        didSet {
            guard let currentQuestion = currentQuestion else { return }
            tableView.allowsSelection = true
            questionLabel.text = currentQuestion.title
            imageView.loadImageUrl(currentQuestion.imageURL, placeholder: nil)
            tableView.reloadData()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never

        loadPokemonDataIfNeeded()
        setupUILayout()
        registerCells()
        view.backgroundColor = .clear
    }
    
    private func registerCells() {
        tableView.register(GameAnswerCell.self, forCellReuseIdentifier: GameAnswerCell.reuseIdentifier)
    }
    
    private func loadPokemonDataIfNeeded() {
        startLoading()
        
        NetworkService.getPokemons { [weak self] (result, error) in
            self?.stopLoading()
            if let _ = error {
                self?.handleError()
                return
            }

            if let result = result, let pokemonNames = PokemonList.model(fromResponseModel: result)?.list.map({ $0.pokemonName }) {
                self?.gameEngine = GameEngine(pokemonNames: pokemonNames)
                self?.startLoading()
                self?.gameEngine?.getQuestion(completion: { (question) in
                    self?.stopLoading()
                    self?.currentQuestion = question
                })
            }
        }
    }
    
    private func setupUILayout() {
        view.addSubview(questionLabel)
        
        questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        questionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        questionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        view.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 30).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
    private func validateAnswer(forSelectedIndexPath indexPath: IndexPath) {
        guard let selectedAnswer = currentQuestion?.answers[indexPath.row], let correctAnswer = currentQuestion?.correctAnswer else { return }
        
        let answerWasCorrect = (selectedAnswer == correctAnswer)
        let cell = tableView.cellForRow(at: indexPath) as! GameAnswerCell
        cell.markAsCorrectAnswer(answerWasCorrect)
        
        if !answerWasCorrect, let correctAnswerIndex = currentQuestion?.answers.firstIndex(of: correctAnswer) {
            let correctAnswerCell = tableView.cellForRow(at: IndexPath(row: correctAnswerIndex, section: 0)) as! GameAnswerCell
            correctAnswerCell.markAsCorrectAnswer(true)
        }
    }
    
    private func getNewQuestion() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.startLoading()
            self?.gameEngine?.getQuestion(completion: { (question) in
                self?.stopLoading()
                self?.currentQuestion = question
            })
        }
    }
}

extension GameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestion?.answers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameAnswerCell.reuseIdentifier, for: indexPath) as! GameAnswerCell
        if let currentQuestion = currentQuestion {
            cell.setup(with: currentQuestion.answers[indexPath.row])
        }
        return cell
    }
}

extension GameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.selectedBackgroundView = UIView()
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        validateAnswer(forSelectedIndexPath: indexPath)
        tableView.allowsSelection = false
        getNewQuestion()
    }
}
