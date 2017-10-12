//
//  ComposeController.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/2/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit
import Firebase

class NewPostController: UIViewController, UITextFieldDelegate {
    
    var currentUser = Users()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBar()
        
        view.backgroundColor = .white
        
        titleTextField.delegate = self
        titleTextField.becomeFirstResponder()
    }
    
    func setupNavBar() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButton))
        let composeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "create_new"), landscapeImagePhone: #imageLiteral(resourceName: "create_new"), style: .plain, target: self, action: #selector(sendPost))
        
        navigationItem.title = "Create new post"
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = composeButton
    }
    
    let titleTextField: UITextField = {
        let title = UITextField()
        title.attributedPlaceholder = NSAttributedString(string: "Add an interesting title..", attributes: [NSAttributedStringKey.foregroundColor: UIColor(white:0, alpha:0.5)])
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 14)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 0.5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let postTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = UIFont.systemFont(ofSize: 12)
        tv.textColor = .black
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func setupViews() {
        
        view.addSubview(titleTextField)
        titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: (titleTextField.font?.pointSize)! + 2).isActive = true
        
        view.addSubview(separator)
        separator.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16).isActive = true
        separator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        separator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(postTextView)
        postTextView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 16).isActive = true
        postTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        postTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        postTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
    }
    
    @objc func sendPost() {
        guard let userId = self.currentUser.uid, let title = self.titleTextField.text, let post = self.postTextView.text else {
            return
        }
        
        if title.isEmpty {
            return
        }
        
        let ref = Database.database().reference()
        let postsRef = ref.child("posts").childByAutoId()
        let timestampAsInt = (Int(NSDate().timeIntervalSince1970))
        let timestamp: NSNumber = NSNumber.init(value: timestampAsInt)
        let values = ["userId": userId, "title": title, "post": post, "timestamp": timestamp] as [String : Any]
        
        postsRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            // Successfully saved the post to the database
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func handleCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendPost()
        return true
    }
}

