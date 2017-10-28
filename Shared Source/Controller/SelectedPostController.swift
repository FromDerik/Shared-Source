//
//  PostController.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/10/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit
import Firebase

class SelectedPostController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    let cellId = "cellId"
    let commentCellId = "commentCellId"
    
    var currentUser = Users()
    var currentPost = Posts()
    
    var comments = [Comments]()
    
    var timer: Timer?
    
    lazy var inputBar: InputBar = {
        let inputBar = InputBar()
        inputBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        inputBar.backgroundColor = .white
        inputBar.sendButton.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        inputBar.textField.delegate = self
        return inputBar
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputBar
        }
    }
    
    override var canBecomeFirstResponder: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavBar()
        observeComments()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func setupCollectionView() {
        collectionView?.backgroundColor = UIColor(r: 229, g: 229, b: 234)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: commentCellId)
    }
    
    func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @objc func observeComments() {
        guard let postId = currentPost.postId else { return }
        
        Database.database().reference().child("comments").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                var comment = Comments()
                comment.userId = dictionary["userId"] as? String
                comment.text = dictionary["text"] as? String
                comment.postId = dictionary["postId"] as? String
                comment.timestamp = dictionary["timestamp"] as? NSNumber
                
                guard comment.postId == postId else { return }
                
                self.comments.insert(comment, at: 0)
                
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.reloadData), userInfo: nil, repeats: false)
                
            }
        }, withCancel: nil)
    }
    
    @objc func reloadData() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    @objc func sendComment() {
        guard let postId = currentPost.postId, let userId = currentUser.uid, let text = inputBar.textField.text, !text.isEmpty else { return }
        
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
        })
        
        inputBar.textField.text = nil
        inputBar.sendButton.isEnabled = false
    }
    
    // CollectionView Delegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell
            
            guard let seconds = currentPost.timestamp?.doubleValue, let userId = currentPost.userId else { return cell }
            
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            
            cell.timestampLabel.text = "• \(dateFormatter.string(from: timestampDate as Date))"
            cell.titleLabel.text = currentPost.title
            cell.postLabel.text = currentPost.post
            
            Database.database().reference().child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    cell.userLabel.text = dictionary["username"] as? String
                }
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentCellId, for: indexPath) as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            
            guard let seconds = comment.timestamp?.doubleValue, let userId = comment.userId else { return cell }
            
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            
            cell.timestampLabel.text = "• \(dateFormatter.string(from: timestampDate as Date))"
            cell.textLabel.text = comment.text
            
            Database.database().reference().child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    cell.userLabel.text = dictionary["username"] as? String
                }
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            guard let postText = currentPost.post, let postTitle = currentPost.title else { return CGSize(width: view.frame.width, height: 100) }
            
            // HomeCell title / user / post labels width
            let approximateWidth = view.frame.width - 28 // Comes from label leading + trailing + estimated insets of label
            let size = CGSize(width: approximateWidth, height: 1000)
            
            // title font size
            let titleAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
            let titleEstimatedFrame = NSString(string: postTitle).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: titleAttributes, context: nil)
            
            // post font size
            let postAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
            let postEstimatedFrame = NSString(string: postText).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: postAttributes, context: nil)
            
            return CGSize(width: view.frame.width, height: titleEstimatedFrame.height + postEstimatedFrame.height + 82) // 82 is the remaining heights of views + spacing in the cell
        } else {
            let comment = comments[indexPath.row - 1]
            
            guard let commentText = comment.text else { return CGSize(width: view.frame.width, height: 100) }
            
            // CommentCell comment width
            let approximateWidth = view.frame.width - 28 // Comes from label leading + trailing + estimated insets of label
            let size = CGSize(width: approximateWidth, height: 1000)
            
            // comment font size
            let commentAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
            let commentEstimatedFrame = NSString(string: commentText).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: commentAttributes, context: nil)
            
            return CGSize(width: view.frame.width, height: commentEstimatedFrame.height + 46) // 46 is the remaining heights of views + spacing in the cell
        }
    }
    
    // TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendComment()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let value = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if value.distance(from: value.startIndex, to: value.endIndex) > 0 {
            inputBar.sendButton.isEnabled = true
        } else {
            inputBar.sendButton.isEnabled  = false
        }
        
        return true
    }
    
}
