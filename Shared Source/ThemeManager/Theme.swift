//
//  ThemeManager.swift
//  Shared Source
//
//  Created by Derik Malcolm on 11/8/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit

let selectedThemeKey = "SelectedTheme"

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
    
    var keyboardAppearance: UIKeyboardAppearance {
        switch self {
        case .light:
            return .default
        case .dark:
            return .dark
        }
    }
    
    var cvBackgroundColor: UIColor {
        switch self {
        case .light:
            return UIColor(r: 229, g: 229, b: 234)
        case .dark:
            return UIColor(r: 20, g: 20, b: 20)
        }
    }
    
    var cvCellBackgroundColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return UIColor(r: 35, g: 35, b: 35)
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
        sharedApplication.delegate?.window??.tintColor = theme.tintColor
        sharedApplication.statusBarStyle = theme.statusBarStyle
        
        UINavigationBar.appearance().barStyle = theme.navBarStyle
        
        let homeController = HomeController()
        let selectedPostController = SelectedPostController()
        
        homeController.collectionView?.backgroundColor = theme.cvBackgroundColor
        selectedPostController.collectionView?.backgroundColor = theme.cvBackgroundColor
    }
    
}
