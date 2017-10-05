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
    var users = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        fetchPosts()
//        fetchUsers()
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let navTitleLabel = UILabel()
        navTitleLabel.text = "Home"
        navTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        navTitleLabel.textColor = .white
        
        navigationItem.titleView = navTitleLabel
        navigationItem.leftBarButtonItem = logoutButton
        
        navigationController?.navigationBar.barTintColor = UIColor(r: 36, g: 52, b: 71)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        collectionView?.backgroundColor = UIColor(named: "darkerBlueColor")
        collectionView?.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            print("No users logged in")
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: String] {
                    // Do stuff with current users info here
                    let user = Users()
                    user.username = dictionary["username"]
                    user.email = dictionary["email"]
                    self.currentUser = user
                }
            }, withCancel: nil)
        }
    }
    
    func fetchPosts() {
        Database.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
                let post = Posts()
                post.user = dictionary["user"]
                post.title = dictionary["title"]
                post.post = dictionary["post"]
                self.posts.append(post)
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
/*    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
                let user = Users()
                user.username = dictionary["username"]
                user.email = dictionary["email"]
                self.users.append(user)
                
                // do stuff with users here
            }
        }, withCancel: nil)
    } */
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    @objc func handleComposeLabelTap(_ sender: UITapGestureRecognizer) {
        let composeController = ComposeController()
        let navController = UINavigationController(rootViewController: composeController)
    	 present(navController, animated: true, completion: nil)
    }
    
    // Collection View Cell
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        cell.userLabel.text = post.user
        cell.titleLabel.text = post.title
        cell.postTextView.text = post.post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // Collection View Header / Footer
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderCell
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleComposeLabelTap(_:)))
        header.addGestureRecognizer(tap)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
}

