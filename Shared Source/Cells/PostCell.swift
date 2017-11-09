//
//  PostCell.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/2/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
//        layer.cornerRadius = 8
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        
        setupViews()
    }
    
    let topSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 0.5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let userLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 0, alpha: 0.75)
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 0, alpha: 0.5)
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(white: 0, alpha: 0.75)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let commentsButton: UIButton = {
        let button = Button(imageName: "comment", highlightedImageName: "comment")
        return button
    }()

    let buttonsView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
//        addSubview(topSeparator)
//        topSeparator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
//        topSeparator.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
//        topSeparator.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
//        topSeparator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        addSubview(userLabel)
        userLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        userLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: userLabel.font.pointSize + 1).isActive = true
        
        addSubview(timestampLabel)
        timestampLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        timestampLabel.leadingAnchor.constraint(equalTo: userLabel.trailingAnchor, constant: 4).isActive = true
        timestampLabel.heightAnchor.constraint(equalTo: userLabel.heightAnchor).isActive = true
        
        addSubview(separator)
        separator.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 8).isActive = true
        separator.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        separator.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        addSubview(postLabel)
        postLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 8).isActive = true
        postLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        postLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        addSubview(buttonsView)
        buttonsView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        buttonsView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        buttonsView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        buttonsView.heightAnchor.constraint(equalToConstant: 16).isActive = true

        buttonsView.addArrangedSubview(commentsButton)
        
//        addSubview(bottomSeparator)
//        bottomSeparator.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
//        bottomSeparator.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
//        bottomSeparator.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
//        bottomSeparator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
