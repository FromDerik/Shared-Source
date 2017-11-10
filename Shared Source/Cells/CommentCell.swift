//
//  CommentCell.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/10/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
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
            self.userLabel.textColor = ThemeManager.currentTheme().cellUserLabelColor
            self.timestampLabel.textColor = ThemeManager.currentTheme().cellUserLabelColor
            self.separator.backgroundColor = ThemeManager.currentTheme().backgroundColor
            self.textLabel.textColor = ThemeManager.currentTheme().cellPostLabelColor
        }
    }
    
    let userLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeManager.currentTheme().cellUserLabelColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeManager.currentTheme().cellUserLabelColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        view.layer.cornerRadius = 0.5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = ThemeManager.currentTheme().cellPostLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(userLabel)
        userLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        userLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: userLabel.font.pointSize + 1).isActive = true
        
        addSubview(timestampLabel)
        timestampLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        timestampLabel.leadingAnchor.constraint(equalTo: userLabel.trailingAnchor, constant: 4).isActive = true
        timestampLabel.heightAnchor.constraint(equalTo: userLabel.heightAnchor).isActive = true
        
        addSubview(separator)
        separator.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 8).isActive = true
        separator.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        separator.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        addSubview(textLabel)
        textLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 8).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
