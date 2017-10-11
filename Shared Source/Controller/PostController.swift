//
//  PostController.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/10/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit
import Firebase

class PostController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let commentCellId = "commentCellId"
    
    var currentUser = Users() {
        didSet {
            print("User has been set to: \(currentUser.uid!)")
        }
    }
    
    var currentPost = Posts() {
        didSet {
            print("Post has been set to: \(currentPost.uid!)")
        }
    }
    
    var comments = [Comments]()
    
    let inputBar = InputBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputBar()
        fetchComments()
        
        collectionView?.backgroundColor = .darkerBlue
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: commentCellId)
        
        navigationController?.navigationBar.barTintColor = .navBlue
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupInputBar() {
        inputBar.backgroundColor = .navBlue
        inputBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(inputBar)
        inputBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        inputBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        inputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        inputBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        inputBar.sendButton.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
    }
    
    func fetchComments() {
        guard let uid = currentPost.uid else {
            return
        }
        Database.database().reference().child("comments").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                print(dictionary)
                let comment = Comments()
                comment.userId = dictionary["userId"] as? String
                comment.text = dictionary["text"] as? String
                comment.postId = dictionary["postId"] as? String
                
                if comment.postId == uid {
                    self.comments.insert(comment, at: 0)
                }
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    @objc func sendComment() {
        guard let postId = currentPost.uid, let userId = currentUser.uid, let text = inputBar.textField.text else {
            return
        }
        
        let ref = Database.database().reference().child("comments").childByAutoId()
        let values = ["postId": postId, "userId": userId, "text": text]
        ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            // Successfully saved the user into the database
//            self.resignFirstResponder()
        })
    }
    
    // Collection View
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
            cell.titleLabel.text = currentPost.title
            cell.userLabel.text = currentPost.user
            cell.postLabel.text = currentPost.post
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentCellId, for: indexPath) as! CommentCell
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
        
        
        return CGSize(width: view.frame.width, height: 50)
    }
    
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if section == 0 {
//            return CGSize(width: view.frame.width, height: 0)
//        }
//        return CGSize(width: view.frame.width, height: 50)
//    }
    
}
