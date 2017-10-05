//
//  ComposeController.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/2/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit
import Firebase

class ComposeController: UIViewController, UITextViewDelegate {
    
    var currentUser = Users()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        view.backgroundColor = UIColor(named: "lighterBlueColor")
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButton))
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleComposeButton))
        
        let navTitleLabel = UILabel()
        navTitleLabel.text = "Create new post"
        navTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        navTitleLabel.textColor = .white
        
        navigationItem.titleView = navTitleLabel
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = composeButton
        
        navigationController?.navigationBar.barTintColor = UIColor(r: 36, g: 52, b: 71)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    let titleTextField: UITextField = {
        let title = UITextField()
        title.attributedPlaceholder = NSAttributedString(string: "Add an interesting title..", attributes: [NSAttributedStringKey.foregroundColor: UIColor(white:1, alpha:0.5)])
        title.textColor = .white
        title.adjustsFontSizeToFitWidth = true
        title.font = UIFont.systemFont(ofSize: 20)
        title.minimumFontSize = 8
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "darkerBlueColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let postTextView: UITextView = {
        let post = UITextView()
        post.font = UIFont.systemFont(ofSize: 12)
        post.textColor = .white
        post.translatesAutoresizingMaskIntoConstraints = false
        return post
    }()
    
    func setupViews() {
        
        view.addSubview(titleTextField)
        titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(separator)
        separator.topAnchor.constraint(equalTo: titleTextField.bottomAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
        separator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(postTextView)
        postTextView.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        postTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        postTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        postTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc func handleComposeButton() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
//                print(dictionary)
                self.currentUser.username = dictionary["username"]
                self.currentUser.email = dictionary["email"]
                
                guard let title = self.titleTextField.text, let post = self.postTextView.text, let user = self.currentUser.username else {
                    return
                }
                
                if title.isEmpty {
                    return
                }
                
                let ref = Database.database().reference()
                let postsRef = ref.child("posts").childByAutoId()
                let values = ["user": user, "title": title, "post": post]
                
                postsRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    // Successfully saved the post to the database
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }, withCancel: nil)
    }
    
    @objc func handleCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

