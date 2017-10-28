//
//  LoginController.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/2/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white //UIColor(r: 61, g: 91, b: 151)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupSegmentedControl()
    }
    
    let loginSegmentedController: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.tintColor = .blue
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue //UIColor(r: 79, g: 101, b: 161)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let usernameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.keyboardType = .emailAddress
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    func setupSegmentedControl() {
    	view.addSubview(loginSegmentedController)
        loginSegmentedController.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        loginSegmentedController.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginSegmentedController.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginSegmentedController.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var usernameTextFieldHeightAnchor: NSLayoutConstraint?
    var usernameSeparatorHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView() {
    	// Container view
    	view.addSubview(inputsContainerView)
    	 inputsContainerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
		inputsContainerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 72)
        inputsContainerViewHeightAnchor?.isActive = true
        
        // Username text field
        inputsContainerView.addSubview(usernameTextField)
        usernameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        usernameTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12).isActive = true
        usernameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        usernameTextFieldHeightAnchor = usernameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
        usernameTextFieldHeightAnchor?.isActive = true
        
        // Username separator view
        inputsContainerView.addSubview(usernameSeparatorView)
        usernameSeparatorView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
        usernameSeparatorView.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor).isActive = true
        usernameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        usernameSeparatorHeightAnchor = usernameSeparatorView.heightAnchor.constraint(equalToConstant: 0)
        usernameSeparatorHeightAnchor?.isActive = true
        
        // Email text field
        inputsContainerView.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        emailTextFieldHeightAnchor?.isActive = true
        
        // Email separator view
        inputsContainerView.addSubview(emailSeparatorView)
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        // Password text field
        inputsContainerView.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
    	view.addSubview(loginRegisterButton)
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    @objc func handleLoginRegister() {
        if loginSegmentedController.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            
            // Successfully signed in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error) in
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.uid else { return }
            
            // Successfully authenticated user
            let ref = Database.database().reference().child("users").child(uid)
            let values = ["username": username, "email": email]
            ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
                // Successfully saved the user into the database
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @objc func handleSegmentChange() {
        let title = loginSegmentedController.titleForSegment(at: loginSegmentedController.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        // Change height of input container view and hide the username text field depending on selected segment
        inputsContainerViewHeightAnchor?.constant = loginSegmentedController.selectedSegmentIndex == 0 ? 72 : 108
        
        usernameTextFieldHeightAnchor?.isActive = false
        usernameTextFieldHeightAnchor = usernameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginSegmentedController.selectedSegmentIndex == 0 ? 0 : 1/3)
        usernameTextFieldHeightAnchor?.isActive = true
        
        usernameSeparatorHeightAnchor?.constant = loginSegmentedController.selectedSegmentIndex == 0 ? 0 : 0.5
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginSegmentedController.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginSegmentedController.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
}

