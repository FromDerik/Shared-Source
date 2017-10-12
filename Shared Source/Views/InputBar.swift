//
//  InputBar.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/11/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit

class InputBar: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add a comment"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    func setupViews() {
        addSubview(separator)
        separator.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        addSubview(sendButton)
        sendButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor).isActive = true
        
        addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
