//
//  HomeController.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/2/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UITableViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var currentUser = Users()
    var currentUserPosts = [Posts]()
    
    var allPosts = [Posts]()
    var allUsers = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        checkIfUserIsLoggedIn()
        
        tableView?.backgroundColor = .lighterBlue
        tableView.separatorColor = .darkerBlue
        tableView.separatorInset.left = 0
        tableView.register(PostCell.self, forCellReuseIdentifier: cellId)
    }
    
    func setupNavBar() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let composeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "create_new"), landscapeImagePhone: #imageLiteral(resourceName: "create_new"), style: .plain, target: self, action: #selector(handleCompose))
        let navTitleLabel = UILabel()
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
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    // Do stuff with current users info here
                    let user = Users()
                    user.username = dictionary["username"] as? String
                    user.email = dictionary["email"] as? String
                    self.currentUser = user
                    
                    self.fetchPosts()
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
                
                // current users posts
                if post.user == self.currentUser.username {
                    self.currentUserPosts.insert(post, at:0)
                }
                
                // all posts
                self.allPosts.insert(post, at:0)
                
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
                let user = Users()
                user.username = dictionary["username"]
                user.email = dictionary["email"]
                self.allUsers.append(user)
                
                // do stuff with users here
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
        let composeController = ComposeController()
        let navController = UINavigationController(rootViewController: composeController)
        present(navController, animated: true, completion: nil)
    }
    
    // Table View Cell
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostCell
        let post = allPosts[indexPath.row]
        cell.userLabel.text = post.user
        cell.titleLabel.text = post.title
        cell.postLabel.text = post.post
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
