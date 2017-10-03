//
//  ComposeController.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/2/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit
import Firebase

class ComposeController: UIViewController {
    
    var currentUser = Users()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "lighterBlueColor")
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButton))
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleComposeButton))
        
        navigationItem.title = "Create new post"
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = composeButton
        
        setupViews()
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
        post.backgroundColor = .clear
        post.translatesAutoresizingMaskIntoConstraints = false
        return post
    }()
    
    let postPlaceholder: UILabel = {
        let placeholder = UILabel()
        placeholder.text = "Aditional text (optional)"
        placeholder.textColor = .lightGray
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        return placeholder
    }()
    
    func setupViews() {
        view.addSubview(titleTextField)
        titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(separator)
        separator.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8).isActive = true
        separator.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        view.addSubview(postTextView)
        postTextView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 8).isActive = true
        postTextView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        postTextView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
        postTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
//        postTextView.addSubview(postPlaceholder)
//        postPlaceholder.topAnchor.constraint(equalTo: postTextView.topAnchor).isActive = true
//        postPlaceholder.leftAnchor.constraint(equalTo: postTextView.leftAnchor).isActive = true
//        postPlaceholder.rightAnchor.constraint(equalTo: postTextView.rightAnchor).isActive = true
//        postPlaceholder.bottomAnchor.constraint(equalTo: postTextView.bottomAnchor).isActive = true
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

