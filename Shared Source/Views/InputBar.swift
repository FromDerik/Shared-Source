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
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add a comment"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = Button(imageName: "send", highlightedImageName: "send")
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.75
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 17
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        addSubview(separator)
        separator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        addSubview(inputContainerView)
        inputContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        inputContainerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        inputContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        inputContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        
        inputContainerView.addSubview(sendButton)
        sendButton.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: -4).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -4).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        inputContainerView.addSubview(textField)
        textField.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: 8).isActive = true
        textField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 8).isActive = true
        textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -4).isActive = true
        textField.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
