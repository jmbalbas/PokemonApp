//
//  BaseViewController.swift
//  PokemonApp
//
//  Created by Juan Santiago Martín Balbás on 12/10/2018.
//  Copyright © 2018 Juan Santiago Martín Balbás. All rights reserved.
//

import UIKit
import Alamofire

class BaseViewController: UIViewController {
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicator)

        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return activityIndicator
    }()
    
    var requests = [DataRequest?]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradientBackground()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        requests.forEach { $0?.cancel() }
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    func handleError() {
        let alertController = UIAlertController(title: "Ops!", message: "There was a problem".localized, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupGradientBackground() {
        let colorTop = UIColor(red: 243 / 255.0, green: 115 / 255.0, blue: 53 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 253 / 255.0, green: 200 / 255.0, blue: 48 / 255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

}
