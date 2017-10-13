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
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var textField: TextField = {
        let textField = TextField()
        textField.placeholder = "Add a comment"
        textField.layer.borderWidth = 0.75
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    func setupViews() {
        addSubview(separator)
        separator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        addSubview(sendButton)
        sendButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(textField)
        textField.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -4).isActive = true
        textField.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.75).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
