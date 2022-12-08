//
//  SettingsViewController.swift
//  FileManager
//
//  Created by kosmokos I on 05.12.2022.
//

import Foundation
import UIKit

final class SettingsViewController: UIViewController {
    
    //MARK: Properties
    
    private lazy var sortLabel: UILabel = {
        let label = UILabel()
        label.text = "Sort alphabetical"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sortSwitch: UISwitch = {
        let sortSwitch = UISwitch()
        sortSwitch.backgroundColor = .white
        sortSwitch.onTintColor = .systemCyan
        sortSwitch.thumbTintColor = .black
        sortSwitch.layer.cornerRadius = 16
        sortSwitch.layer.masksToBounds = true
        sortSwitch.translatesAutoresizingMaskIntoConstraints = false
        return sortSwitch
    }()
    
    private lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change password", for: .normal)
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey: "sort") == "on" {
            sortSwitch.isOn = true
        } else {
            sortSwitch.isOn = false
        }
    }
    
    //MARK: - Methods
    
    private func setupUI() {
        setupViews()
        setupConstraints()
        addTargets()
        
        navigationItem.title = "Settings"
    }
    
    private func setupViews() {
        view.addSubview(sortLabel)
        view.addSubview(sortSwitch)
        view.addSubview(changePasswordButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
        
            sortLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            sortLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        
            sortSwitch.centerYAnchor.constraint(equalTo: sortLabel.centerYAnchor),
            sortSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            changePasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            changePasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            changePasswordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func addTargets() {
        sortSwitch.addTarget(self, action: #selector(sortAlphabetical), for: .valueChanged)
        changePasswordButton.addTarget(self, action: #selector(showLoginVC), for: .touchUpInside)
    }
    
    @objc
    private func sortAlphabetical() {
        if sortSwitch.isOn {
            UserDefaults.standard.set("on", forKey: "sort")
        } else {
            UserDefaults.standard.set("off", forKey: "sort")
        }
    }
    
    @objc
    private func showLoginVC() {
        let loginVC = LoginViewController()
        loginVC.loginStatus = .changePassword
        
        navigationController?.present(loginVC, animated: true)
    }
    
}
