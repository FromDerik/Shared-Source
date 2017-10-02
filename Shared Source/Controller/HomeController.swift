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
    let footerId = "footerId"
    
    var posts = [Posts]()
    var users = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        fetchPosts()
//        fetchUsers()
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem = logoutButton
        
        collectionView?.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        collectionView?.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
                let user = Users()
                user.username = dictionary["username"]
                user.email = dictionary["email"]
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    func fetchPosts() {
        Database.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: String] {
//                print(dictionary)
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
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            print("No users logged in")
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    // Do stuff with current users info here
                    self.navigationItem.title = dictionary["username"] as? String
                }
            }, withCancel: nil)
        }
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
    
    @objc func handleComposeLabelTap(_ sender: UITapGestureRecognizer) {
        let composeController = ComposeController()
        let composeNavbarController = UINavigationController(rootViewController: composeController)
        present(composeNavbarController, animated: true, completion: nil)
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
    
    // Collection View Header / Footer
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderCell
//        header.backgroundColor = .blue
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleComposeLabelTap(_:)))
        header.addGestureRecognizer(tap)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
}

