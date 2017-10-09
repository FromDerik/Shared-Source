//
//  PostCell.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/2/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .lighterBlue
        setupViews()
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .darkerBlue
        view.layer.cornerRadius = 0.5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let userLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 1, alpha: 0.5)
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let commentsButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(HomeController.handleCompose), for: .touchUpInside)
        return button
    }()
    
    func setupViews() {
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
//        titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.font.pointSize + 1).isActive = true
        
        addSubview(userLabel)
        userLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        userLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        userLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: userLabel.font.pointSize + 1).isActive = true
        
        addSubview(separator)
        separator.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 8).isActive = true
        separator.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        separator.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(postLabel)
        postLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 8).isActive = true
        postLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        postLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        postLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
