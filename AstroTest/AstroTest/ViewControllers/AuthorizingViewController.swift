//
//  AuthorizingViewController.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 25.10.2024.
//

import UIKit

class AuthorizingViewController: UIViewController {

    // MARK: - Properties
    
    var token: String = ""
    
    // MARK: - Visual components
    
    var tokenTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.placeholder = "Enter your token"
        return textField
    }()
    
    var getGistsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(#colorLiteral(red: 0, green: 0.3351471424, blue: 0.5525879264, alpha: 1))
        button.layer.cornerRadius = 10
        button.setTitle("get gists", for: .normal)
        button.addTarget(self, action: #selector(getGistsButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupView()
        tokenTextField.delegate = self
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        view.addSubview(tokenTextField)
        view.addSubview(getGistsButton)
        
        tokenTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tokenTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tokenTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        
        getGistsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        getGistsButton.topAnchor.constraint(equalTo: tokenTextField.bottomAnchor, constant: 20).isActive = true
        getGistsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 55).isActive = true
    }
    
    // MARK: - Actions
    
    @objc private func getGistsButtonPressed(_ sender: Any) {
        if !token.isEmpty {
            TokenService.shared.token = token
        }
        let nextVC = GistListViewController()
        let navigationController = UINavigationController(rootViewController: nextVC)
        navigationController.navigationBar.tintColor = .white
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension AuthorizingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField)  {
        token = textField.text ?? ""
    }
}

