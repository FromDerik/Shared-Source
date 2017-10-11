//
//  HomeController.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/2/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var currentUser = Users()
    var posts = [Posts]()
    
    let navTitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        fetchPosts()
        
        collectionView?.backgroundColor = .darkerBlue
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfUserIsLoggedIn()
    }
    
    func setupNavBar() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let composeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "create_new"), landscapeImagePhone: #imageLiteral(resourceName: "create_new"), style: .plain, target: self, action: #selector(handleCompose))
        
        navTitleLabel.attributedText = NSAttributedString(string: "Home", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        navigationItem.titleView = navTitleLabel
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItem = composeButton
        
        navigationController?.navigationBar.barTintColor = .navBlue
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    // Do stuff with current users info here
                    
                    let user = Users()
                    user.username = dictionary["username"] as? String
                    user.email = dictionary["email"] as? String
                    user.uid = snapshot.key
                    
                    self.currentUser = user
                }
            }, withCancel: nil)
        }
    }
    
    func fetchPosts() {
        Database.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let post = Posts()
                post.user = dictionary["user"] as? String
                post.title = dictionary["title"] as? String
                post.post = dictionary["post"] as? String
                
                self.posts.insert(post, at:0)
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    @objc func handleCompose() {
        let newPostController = NewPostController()
        newPostController.currentUser = self.currentUser
        let navController = UINavigationController(rootViewController: newPostController)
        present(navController, animated: true, completion: nil)
    }
    
    // Collection View
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
        let post = posts[indexPath.row]
        
        cell.userLabel.text = post.user
        cell.titleLabel.text = post.title
        cell.postLabel.text = post.post
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let post = posts[indexPath.row]
        
        if let postText = post.post, let postTitle = post.title {
        	
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
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let postController = PostController(collectionViewLayout: UICollectionViewFlowLayout())
        postController.post = post
        postController.currentUser = self.currentUser
        
        navigationController?.pushViewController(postController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath)
        view.backgroundColor = .black
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
}
