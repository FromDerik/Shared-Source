//
//  HeaderCell.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/2/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit
import Firebase

class HeaderCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let compostPostLabel: UILabel = {
        let label = UILabel()
        label.text = "Post something interesting"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(compostPostLabel)
        compostPostLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        compostPostLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        compostPostLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        compostPostLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
