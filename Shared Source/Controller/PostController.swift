//
//  PostController.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/10/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit
import Firebase

class PostController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    let cellId = "cellId"
    let commentCellId = "commentCellId"
    
    var currentUser = Users()
    var currentPost = Posts()
    
    var comments = [Comments]()
    
    let inputBar = InputBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputBar()
        fetchComments()
        setupKeyboardObserver()
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.backgroundColor = UIColor(r: 229, g: 229, b: 234)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: commentCellId)
    }
    
    func setupKeyboardObserver() {
    	NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
    	
    	NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func handleKeyboardWillShow(notification: NSNotification) {
    	let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey].cgRectValue
    	
    	inputBarBottomAnchor?.constant = -keyboardFrame!.height
    }
    
    func handleKeyboardWillShow(notification: NSNotification) {
    	inputBarBottomAnchor?.constant = 0
    }
    
    var inputBarBottomAnchor: NSLayoutConstraint?
    
    func setupInputBar() {
        inputBar.backgroundColor = .white
        inputBar.translatesAutoresizingMaskIntoConstraints = false
        inputBar.sendButton.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        inputBar.textField.delegate = self
        
        view.addSubview(inputBar)
        inputBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        inputBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        inputBarBottomAnchor = inputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        inputBarBottomAnchor?.isActive = true
        inputBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let xView = UIView()
        xView.backgroundColor = .white
        xView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(xView)
        xView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        xView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        xView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        xView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func fetchComments() {
        guard let postId = currentPost.postId else {
            return
        }
        Database.database().reference().child("comments").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let comment = Comments()
                comment.userId = dictionary["userId"] as? String
                comment.text = dictionary["text"] as? String
                comment.postId = dictionary["postId"] as? String
                comment.timestamp = dictionary["timestamp"] as? NSNumber
                
                if comment.postId == postId {
                    self.comments.insert(comment, at: 0)
                }
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    @objc func sendComment() {
        guard let postId = currentPost.postId, let userId = currentUser.uid, let text = inputBar.textField.text else {
            return
        }
        
        let ref = Database.database().reference().child("comments").childByAutoId()
        let timestampAsInt = (Int(NSDate().timeIntervalSince1970))
        let timestamp: NSNumber = NSNumber.init(value: timestampAsInt)
        let values = ["postId": postId, "userId": userId, "text": text, "timestamp": timestamp] as [String : Any]
        ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            // Successfully saved the comment into the database
            self.inputBar.textField.resignFirstResponder()
            self.inputBar.textField.text = nil
        })
    }
    
    // Collection View
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell
            cell.titleLabel.text = currentPost.title
            cell.postLabel.text = currentPost.post
            
            if let seconds = currentPost.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                
                cell.timestampLabel.text = "• \(dateFormatter.string(from: timestampDate as Date))"
            }
            
            let userId = currentPost.userId
            Database.database().reference().child("users").child(userId!).observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    cell.userLabel.text = dictionary["username"] as? String
                }
            }
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentCellId, for: indexPath) as! CommentCell
        let comment = comments[indexPath.row - 1]
        
        if let uid = comment.userId {
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    cell.userLabel.text = dictionary["username"] as? String
                    cell.textLabel.text = comment.text
                    
                    if let seconds = comment.timestamp?.doubleValue {
                        let timestampDate = NSDate(timeIntervalSince1970: seconds)
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "hh:mm a"
                        
                        cell.timestampLabel.text = "• \(dateFormatter.string(from: timestampDate as Date))"
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            if let postText = currentPost.post, let postTitle = currentPost.title {
                
                // HomeCell title / user / post labels width
                let approximateWidth = view.frame.width - 12 - 12 - 4
                let size = CGSize(width: approximateWidth, height: 1000)
                
                // title font size
                let titleAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
                let titleEstimatedFrame = NSString(string: postTitle).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: titleAttributes, context: nil)
                
                // post font size
                let postAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
                let postEstimatedFrame = NSString(string: postText).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: postAttributes, context: nil)
                
                // 82 is the remaining heights of views + spacing in the cell
                return CGSize(width: view.frame.width, height: titleEstimatedFrame.height + postEstimatedFrame.height + 82)
            }
        }
        
        let comment = comments[indexPath.row - 1]
        if let commentText = comment.text {
            
            // CommentCell comment width
            let approximateWidth = view.frame.width - 12 - 12 - 4
            let size = CGSize(width: approximateWidth, height: 1000)
            
            // comment font size
            let commentAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
            let commentEstimatedFrame = NSString(string: commentText).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: commentAttributes, context: nil)
            
            // 46 is the remaining heights of views + spacing in the cell
            return CGSize(width: view.frame.width, height: commentEstimatedFrame.height + 46)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendComment()
        return true
    }
    
}
