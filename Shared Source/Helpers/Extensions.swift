//
//  Extensions.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/2/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static var lighterBlue = UIColor(r: 27, g: 40, b: 54)
    static var normalBlue = UIColor(r: 23, g: 35, b: 46)
    static var darkerBlue = UIColor(r: 20, g: 29, b: 38)
}
