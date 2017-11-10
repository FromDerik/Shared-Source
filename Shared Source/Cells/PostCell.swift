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
        
        backgroundColor = ThemeManager.currentTheme().cellBackgroundColor
        
        setupViews()
        createObservers()
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTheme(notification:)), name: themeNotificationName, object: nil)
    }
    
    @objc func updateTheme(notification: NSNotification) {
        UIView.animate(withDuration: 0.25) {
            self.backgroundColor = ThemeManager.currentTheme().cellBackgroundColor
            self.titleLabel.textColor = ThemeManager.currentTheme().cellTitleLabelColor
            self.postLabel.textColor = ThemeManager.currentTheme().cellPostLabelColor
            self.userLabel.textColor = ThemeManager.currentTheme().cellUserLabelColor
            self.timestampLabel.textColor = ThemeManager.currentTheme().cellUserLabelColor
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = ThemeManager.currentTheme().cellTitleLabelColor
        label.font = UIFont.systemFont(ofSize: defaultTextSize + 2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: defaultTextSize)
        label.textColor = ThemeManager.currentTheme().cellPostLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeManager.currentTheme().cellUserLabelColor
        label.font = UIFont.systemFont(ofSize: defaultTextSize, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeManager.currentTheme().cellUserLabelColor
        label.font = UIFont.systemFont(ofSize: defaultTextSize, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let commentsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "comment_outlined"), for: .normal)
        button.setImage(UIImage(named: "comment_filled"), for: .highlighted)
        return button
    }()

    let buttonsView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: defaultPadding).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: defaultPadding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -defaultPadding).isActive = true
        
        addSubview(postLabel)
        postLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: defaultPadding).isActive = true
        postLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: defaultPadding).isActive = true
        postLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -defaultPadding).isActive = true
        
        addSubview(userLabel)
//        userLabel.topAnchor.constraint(equalTo: postLabel.bottomAnchor, constant: defaultPadding / 2).isActive = true
        userLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: defaultPadding).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: userLabel.font.pointSize + 1).isActive = true
        userLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -defaultPadding).isActive = true
        
        addSubview(timestampLabel)
//        timestampLabel.topAnchor.constraint(equalTo: postLabel.bottomAnchor, constant: defaultPadding / 2).isActive = true
        timestampLabel.leadingAnchor.constraint(equalTo: userLabel.trailingAnchor, constant: 4).isActive = true
        timestampLabel.heightAnchor.constraint(equalTo: userLabel.heightAnchor).isActive = true
        timestampLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -defaultPadding).isActive = true
        
//        addSubview(separator)
//        separator.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 8).isActive = true
//        separator.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
//        separator.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
//        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
//        addSubview(buttonsView)
//        buttonsView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
//        buttonsView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
//        buttonsView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
//        buttonsView.heightAnchor.constraint(equalToConstant: 16).isActive = true
//
//        buttonsView.addArrangedSubview(commentsButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
