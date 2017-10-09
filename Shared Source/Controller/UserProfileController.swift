//
//  UserProfileController.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/9/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UITableViewController {
    
    let navTitleLabel = UILabel()
    
    var currentUser = Users()
    var currentUsersPosts = [Posts]()
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        
        tableView?.backgroundColor = .lighterBlue
        tableView.separatorColor = .darkerBlue
        tableView.separatorInset.left = 0
        tableView.register(HomeCell.self, forCellReuseIdentifier: cellId)
        tableView.register(ProfileHeaderCell.self, forCellReuseIdentifier: headerId)
    }
    
    func setupNavBar() {
        let menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), landscapeImagePhone: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(handleMenu))
        
        navTitleLabel.attributedText = NSAttributedString(string: self.currentUser.username!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        navTitleLabel.sizeToFit()
        
        navigationItem.titleView = navTitleLabel
        navigationItem.rightBarButtonItem = menuButton
        
        navigationController?.navigationBar.barTintColor = .navBlue
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func checkIfUserIsLoggedIn() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let user = Users()
                user.username = dictionary["username"] as? String
                user.email = dictionary["email"] as? String
                self.currentUser = user
                
                self.setupNavBar()
                self.fetchPosts()
            }
        }, withCancel: nil)
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
                    self.currentUsersPosts.insert(post, at:0)
                }
                
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    @objc func handleMenu() {
    }
    
    // Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsersPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeCell
        let post = currentUsersPosts[indexPath.row]
        cell.userLabel.text = post.user
        cell.titleLabel.text = post.title
        cell.postLabel.text = post.post
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: headerId) as! ProfileHeaderCell
        return cell
    }
    
    
    
}
