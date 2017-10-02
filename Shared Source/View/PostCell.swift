//
//  PostCell.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/2/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        self.backgroundColor = .white
    }
    
    let userLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .red
        label.textColor = UIColor(r:55, g:55, b:55)
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .green
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let postTextView: UITextView = {
        let tv = UITextView()
//        tv.backgroundColor = .blue
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let cellSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
//        self.backgroundColor = .yellow
        
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(userLabel)
        userLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        userLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        userLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(postTextView)
        postTextView.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 8).isActive = true
        postTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        postTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        postTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        addSubview(cellSeparator)
        cellSeparator.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellSeparator.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        cellSeparator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cellSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
