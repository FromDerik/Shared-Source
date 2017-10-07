//
//  Picker.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/6/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit

class Picker: UIView {

	var isOpen = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showViews(_:)))
        addGestureRecognizer(tap)
        self.clipsToBounds = false
    }
    
    var selectedLabel: UILabel = {
    	let label = UILabel(frame: self.frame)
    	label.font = UIFont.systemFont(ofSize: 14, weight: .light)
    	label.textAlignment = .center
    	return label
    }()
    
    let firstView: UIView = {
    	let view = UIView()
    	view.alpha = 0
    	
    	let label = UILabel(frame: view.frame)
    	label.text = "New to old"
    	label.textAlignment = .center
    	
    	view.addSubview(label)
    	return view
    }()
    
    let secondView: UIView = {
    	let view = UIView()
    	view.backgroundColor = .darkerBlue
    	view.alpha = 0
    	
    	let label = UILabel(frame: view.frame)
    	label.text = "Old to new"
    	label.textAlignment = .center
    	
    	view.addSubview(label)
    	return view
    }()
    
    func setupViews() {
    	addSubview(selectedLabel)
    	addSubview(firstView)
    	addSubview(secondView)
    }
    
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
    
    	if isOpen == false {
	    	UIView.animate(duration: 0.25, animations: {
	    		let newY = self.frame.origin.y + self.frame.height
	    		firstView.frame = CGRect(x: self.frame.origin.x, y: newY, width: self.frame.width, height: self.frame.height)
	    		firstView.alpha = 1
	    	}, completion: {
	    		UIView.animate(duration: 0.25, animations: {
	    			let newY = firstView.frame.origin.y + firstView.frame.height
	    			secondView.frame = CGRect(x: secondView.frame.origin.x, y: newY, width: secondView.frame.width, height: secondView.frame.height)
	    			secondView.alpha = 1
	    		}, completion: {isOpen = true})
	    	})
    	}
    	
	}
}
    