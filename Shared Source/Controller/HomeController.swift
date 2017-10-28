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
    
    var currentUser = Users() {
        didSet {
            navigationItem.title = currentUser.username
        }
    }
    
    var posts = [Posts]()
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavBar()
        observePosts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfUserIsLoggedIn()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func setupCollectionView() {
        collectionView?.backgroundColor = UIColor(r: 229, g: 229, b: 234)
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    func setupNavBar() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleCompose))
        let searchController = UISearchController(searchResultsController: nil)
        
        navigationItem.searchController = searchController
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItem = composeButton
        navigationController?.navigationBar.prefersLargeTitles = true
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
                    
                    var user = Users()
                    user.username = dictionary["username"] as? String
                    user.email = dictionary["email"] as? String
                    user.uid = snapshot.key
                    
                    self.currentUser = user
                }
            }, withCancel: nil)
        }
    }
    
    @objc func observePosts() {
        Database.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                var post = Posts()
                post.title = dictionary["title"] as? String
                post.post = dictionary["post"] as? String
                post.userId = dictionary["userId"] as? String
                post.timestamp = dictionary["timestamp"] as? NSNumber
                post.postId = snapshot.key
                
                self.posts.insert(post, at:0)
                
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.reloadData), userInfo: nil, repeats: false)
            }
        }, withCancel: nil)
    }
    
    @objc func reloadData() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        collectionView?.refreshControl?.endRefreshing()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        
        guard let seconds = post.timestamp?.doubleValue, let userId = post.userId else { return cell }
        
        let timestampDate = NSDate(timeIntervalSince1970: seconds)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        cell.timestampLabel.text = "• \(dateFormatter.string(from: timestampDate as Date))"
        cell.titleLabel.text = post.title
        cell.postLabel.text = post.post
        
        Database.database().reference().child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                cell.userLabel.text = dictionary["username"] as? String
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let post = posts[indexPath.row]
        
        guard let postText = post.post, let postTitle = post.title else {
        	return CGSize(width: view.frame.width, height: 100)
        }
        
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        let selectedPostController = SelectedPostController(collectionViewLayout: UICollectionViewFlowLayout())
        selectedPostController.currentPost = post
        selectedPostController.currentUser = self.currentUser
        
        navigationItem.title = "Home"
        navigationController?.pushViewController(selectedPostController, animated: true)
    }
    
}
