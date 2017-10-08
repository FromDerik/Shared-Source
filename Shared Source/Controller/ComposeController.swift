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
        
        view.backgroundColor = .lighterBlue
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButton))
        let composeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "create_new"), landscapeImagePhone: #imageLiteral(resourceName: "create_new"), style: .plain, target: self, action: #selector(handleComposeButton))
        
        let navTitleLabel = UILabel()
        navTitleLabel.text = "Create new post"
        navTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        navTitleLabel.textColor = .white
        
        navigationItem.titleView = navTitleLabel
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = composeButton
        navigationController?.navigationBar.barTintColor = .navBlue
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
        view.backgroundColor = .darkerBlue
        view.layer.cornerRadius = 0.5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let postTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = UIFont.systemFont(ofSize: 12)
        tv.textColor = .white
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func setupViews() {
        
        view.addSubview(titleTextField)
        titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: (titleTextField.font?.pointSize)! + 1).isActive = true
        
        view.addSubview(separator)
        separator.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 4).isActive = true
        separator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        separator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(postTextView)
        postTextView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 4).isActive = true
        postTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        postTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        postTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
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

