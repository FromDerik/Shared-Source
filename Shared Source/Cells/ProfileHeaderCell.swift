//
//  ProfileHeaderCell.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/9/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .lighterBlue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
