//
//  Button.swift
//  Shared Source
//
//  Created by Derik Malcolm on 11/7/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit

class Button: UIButton {
    var defaultImage: UIImage!
    var highlightedImage: UIImage!
    
    override var buttonType: UIButtonType {
        get {
            return .system
        }
    }
    
    public init(imageName: String) {
        defaultImage = UIImage(named: "\(imageName)_outlined")
        
        super.init(frame: .zero)
        
        setImage(defaultImage, for: .normal)
    }
    
    public init(imageName: String, highlightedImageName: String?) {
        
        
        defaultImage = UIImage(named: "\(imageName)_outlined")
        
        if let highlightedName = highlightedImageName {
            highlightedImage = UIImage(named: "\(highlightedName)_filled")
        } else {
            print(String(describing: highlightedImageName))
        }
        
        super.init(frame: .zero)
        
        setImage(defaultImage, for: .normal)
    
        if highlightedImage != nil {
            setImage(highlightedImage, for: .highlighted)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
