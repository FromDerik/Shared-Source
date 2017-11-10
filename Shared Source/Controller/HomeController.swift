//
//  HomeController.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/2/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate {
    
    let cellId = "cellId"
    let headerId = "headerId"
    var timer: Timer?
    var posts = [Posts]()
    var currentUser = Users() {
        didSet {
            navigationItem.title = currentUser.username
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavBar()
        observePosts()
        createObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfUserIsLoggedIn()
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTheme(notification:)), name: themeNotificationName, object: nil)
    }
    
    @objc func updateTheme(notification: NSNotification) {
        UIView.animate(withDuration: 0.25) {
            self.collectionView?.backgroundColor = ThemeManager.currentTheme().backgroundColor
            self.navigationController?.navigationBar.barStyle = ThemeManager.currentTheme().navBarStyle
            self.navigationController?.navigationBar.barTintColor = ThemeManager.currentTheme().navBarTintColor
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func setupCollectionView() {
        self.collectionView?.backgroundColor = ThemeManager.currentTheme().backgroundColor
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    func setupNavBar() {
//        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
//        let darkModeButton = UIBarButtonItem(image: UIImage(named: "darkButton_outlined"), style: .plain, target: self, action: #selector(handleThemeChanged))
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleCompose))
        let searchController = UISearchController(searchResultsController: nil)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleThemeChanged(sender:)))
        gesture.minimumPressDuration = 1.5
        gesture.allowableMovement = 0.2
        
        navigationItem.searchController = searchController
//        navigationItem.leftBarButtonItem = darkModeButton
        navigationItem.rightBarButtonItem = composeButton
        
        navigationController?.navigationBar.barStyle = ThemeManager.currentTheme().navBarStyle
        navigationController?.navigationBar.barTintColor = ThemeManager.currentTheme().navBarTintColor
        navigationController?.navigationBar.addGestureRecognizer(gesture)
    }
    
    @objc func handleThemeChanged(sender: UILongPressGestureRecognizer) {
        let currentTheme = ThemeManager.currentTheme()
        
        if sender.state == .began {
            switch currentTheme {
            case .light:
                ThemeManager.apply(theme: .dark)
            case .dark:
                ThemeManager.apply(theme: .light)
            }
        }
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
        
        guard let seconds = post.timestamp?.doubleValue, let userId = post.userId else {
            return cell
        }
        
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
        let approximateWidth = view.frame.width - defaultPadding * 2 - 4
        let size = CGSize(width: approximateWidth, height: 1000)
        
        // title font size
        let titleAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
        let titleEstimatedFrame = NSString(string: postTitle).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: titleAttributes, context: nil)
        
        // post font size
        let postAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
        let postEstimatedFrame = NSString(string: postText).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: postAttributes, context: nil)
        
        // 89 is the remaining heights of views + spacing in the cell
        let remainingHeight = defaultPadding + defaultPadding + (defaultPadding / 2) + 13 + defaultPadding
        
        return CGSize(width: view.frame.width, height:  titleEstimatedFrame.height + postEstimatedFrame.height + remainingHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        let selectedPostController = SelectedPostController(collectionViewLayout: layout)
        selectedPostController.currentPost = post
        selectedPostController.currentUser = self.currentUser
        
        navigationItem.title = "Home"
        navigationController?.pushViewController(selectedPostController, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
