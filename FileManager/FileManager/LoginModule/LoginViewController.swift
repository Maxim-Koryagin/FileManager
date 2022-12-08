//
//  LoginViewController.swift
//  FileManager
//
//  Created by kosmokos I on 06.12.2022.
//
import Foundation
import UIKit
import KeychainSwift

final class LoginViewController: UIViewController {

    // MARK: - Properties
    
    var didSentEventClosure: ((LoginViewController.Event) -> Void)?
    
    var loginStatus: LoginStatus {
        didSet {
            setupLoginStatus()
        }
    }
    
    private var credentials = Credentials(username: "kosmokos", password: "")
    
    private let keychain = KeychainSwift(keyPrefix: "kosmokos")
    
    private var numberOfAttempts: NumberOfAttempts = .first
    
    private let minimumPasswordNumbers = 4
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Registration"
        label.font = UIFont(name: "Copperplate", size: 28)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 4
        label.layer.shadowOpacity = 0.7
        label.layer.shadowOffset = CGSize(width: 4, height: 4)
        label.layer.masksToBounds = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .roundedRect
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16)
        textField.placeholder = "Password"
        textField.layer.borderWidth = 0.8
        textField.layer.cornerRadius = 3
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowRadius = 4
        textField.layer.shadowOpacity = 0.7
        textField.layer.shadowOffset = CGSize(width: 4, height: 4)
        textField.textContentType = .oneTimeCode
        textField.autocapitalizationType = .none
        textField.layer.masksToBounds = false
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var loginbutton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 3
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.masksToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - Init and deinit
    
    init(loginStatus: LoginStatus = .userNotAuthorized) {
        self.loginStatus = loginStatus
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("LoginVC deinit")
    }
    
    // MARK: - Methods

    private func setupUI() {
        view.backgroundColor = .systemGray6
        setupNavBar()
        setupViews()
        setupConstraints()
        setupGestures()
        
        if loginStatus == .changePassword {
            titleLabel.text = "Change Password"
            self.loginbutton.addTarget(self, action: #selector(changePasswordButtonAction), for: .touchUpInside)
        } else {
            self.loginbutton.addTarget(self, action: #selector(registrationButtonAction), for: .touchUpInside)
        }
        
        if keychain.getBool(credentials.serviceName) == false {
            loginStatus = .userAutorized
        } else {
            loginStatus = .userNotAuthorized
        }
    }
    
    private func setupLoginStatus() {
        switch loginStatus {
        case .userNotAuthorized:
            loginbutton.setTitle("Create a password", for: .normal)
        case .userAutorized:
            loginbutton.setTitle("Enter", for: .normal)
        case .repeatPassword:
            loginbutton.setTitle("Confirm", for: .normal)
        case .changePassword:
            loginbutton.setTitle("Enter", for: .normal)
        }
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginbutton)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 300),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 38),
            
            loginbutton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 35),
            loginbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            loginbutton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64),
            loginbutton.heightAnchor.constraint(equalToConstant: 45)

        ])
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forcedHidingKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func changePasswordButtonAction() {
        guard let password = passwordTextField.text, password.count >= minimumPasswordNumbers else {
            showWarningAlert(message: "The password must consist more than 4 digits")
            return
        }
     
        keychain.set(password, forKey: credentials.serviceName)
       
        showSuccessAlert(message: "Password Changed to: \(password)")
        passwordTextField.text = ""
    }
    
    @objc
    private func registrationButtonAction() {
        guard let password = passwordTextField.text, password.count >= minimumPasswordNumbers else {
            showWarningAlert(message: "The password must consist more than 4 digits")
            return
        }
        
        if loginStatus == .userNotAuthorized || loginStatus == .repeatPassword {
            switch numberOfAttempts {
            case .first:
                credentials.password = password
                keychain.set(password, forKey: credentials.serviceName)
                numberOfAttempts = .second
                loginStatus = .repeatPassword
            case .second:
                if let getPassword = keychain.get(credentials.serviceName), getPassword == password {
                    didSentEventClosure?(.login)
                    loginStatus = .userAutorized
                    showTabBar()
                } else {
                    showWarningAlert(message: "Password don't match. Please try again")
                    keychain.delete(credentials.username)
                    numberOfAttempts = .first
                    loginStatus = .userNotAuthorized
                }
            }

        } else if let getPaswword = keychain.get(credentials.serviceName), getPaswword == password {
            didSentEventClosure?(.login)
            showTabBar()
        } else {
            showWarningAlert(message: "Wrong password. Please try again")
        }
        passwordTextField.text = ""
    }

    @objc
    private func forcedHidingKeyboard() {
        self.view.endEditing(true)
    }
    
    private func showTabBar() {
        let tabBarController = TabBarController()
        navigationController?.pushViewController(tabBarController, animated: true)
    }
    
}

//MARK: - Exextensions

extension LoginViewController {
    enum Event {
        case login
    }
}

extension LoginViewController {
    enum LoginStatus {
        case userNotAuthorized
        case userAutorized
        case repeatPassword
        case changePassword
    }
    
    enum NumberOfAttempts {
        case first
        case second
    }
    
}

extension LoginViewController {
    func showWarningAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

    func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
}
