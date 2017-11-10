//
//  ThemeManager.swift
//  Shared Source
//
//  Created by Derik Malcolm on 11/8/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit

enum Theme: Int {
    case light, dark
    
    var tintColor: UIColor {
        switch self {
        case .light:
            return UIColor(r: 74, g: 144, b: 226)
        case .dark:
            return .white
        }
    }
    
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .light:
            return .default
        case .dark:
            return .lightContent
        }
    }
    
    var navBarStyle: UIBarStyle {
        switch self {
        case .light:
            return .default
        case .dark:
            return .black
        }
    }
    
    var navBarTintColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return UIColor(r: 36, g: 52, b: 71)
        }
    }
    
    var keyboardAppearance: UIKeyboardAppearance {
        switch self {
        case .light:
            return .default
        case .dark:
            return .dark
        }
    }
    
    // CollectionViewController
    
    var backgroundColor: UIColor {
        switch self {
        case .light:
            return UIColor(r: 229, g: 229, b: 234)
        case .dark:
            return UIColor(r: 20, g: 29, b: 38)
        }
    }
    
    // CollectionViewCell
    
    var cellBackgroundColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return UIColor(r: 27, g: 40, b: 54)
        }
    }
    
    var cellTitleLabelColor: UIColor {
        switch self {
        case .light:
            return .black
        case .dark:
            return .white
        }
    }
    
    var cellPostLabelColor: UIColor {
        switch self {
        case .light:
            return UIColor(white: 0, alpha: 0.75)
        case .dark:
            return UIColor(white: 1, alpha: 0.75)
        }
    }
    
    var cellUserLabelColor: UIColor {
        switch self {
        case .light:
            return UIColor(white: 0, alpha: 0.5)
        case .dark:
            return UIColor(white: 1, alpha: 0.5)
        }
    }
}

struct ThemeManager {
    
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: selectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .light
        }
    }
    
    static func apply(theme: Theme) {
        UserDefaults.standard.set(theme.rawValue, forKey: selectedThemeKey)
        UserDefaults.standard.synchronize()
        
        let sharedApplication = UIApplication.shared
        sharedApplication.statusBarStyle = theme.statusBarStyle

        NotificationCenter.default.post(name: themeNotificationName, object: nil)
    }
    
}
