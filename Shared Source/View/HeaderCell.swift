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
        self.backgroundColor = .white
    }
    
    let composeLabel: UILabel = {
        let label = UILabel()
        label.text = "Post something interesting"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cellSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        
        addSubview(cellSeparator)
        cellSeparator.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellSeparator.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        cellSeparator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cellSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(composeLabel)
        composeLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        composeLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        composeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        composeLabel.bottomAnchor.constraint(equalTo: cellSeparator.topAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
