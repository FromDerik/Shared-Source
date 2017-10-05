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
        setupViews()
        
        view.backgroundColor = UIColor(named: "darkerBlueColor")
        
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
    
    let titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "lighterBlueColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    let postTextView: UITextView = {
        let post = UITextView()
        post.font = UIFont.systemFont(ofSize: 12)
        post.textColor = .white
        post.backgroundColor = UIColor(named: "lighterBlueColor")
//        post.textContainerInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        post.translatesAutoresizingMaskIntoConstraints = false
        return post
    }()
    
    func setupViews() {
        view.addSubview(titleContainerView)
        titleContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        titleContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        titleContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        titleContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        titleContainerView.addSubview(titleTextField)
        titleTextField.topAnchor.constraint(equalTo: titleContainerView.topAnchor).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 5).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor, constant: -5).isActive = true
        titleTextField.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor).isActive = true
        
        view.addSubview(postTextView)
        postTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8).isActive = true
        postTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        postTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        postTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
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

