//
//  SearchController.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/8/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import UIKit
import Firebase

class SearchController: UITableViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var users = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .lighterBlue
        tableView.separatorColor = .darkerBlue
        tableView.separatorInset.left = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        navigationController?.navigationBar.barTintColor = .navBlue
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        fetchUsers()
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
                let user = Users()
                user.username = dictionary["username"]
                user.email = dictionary["email"]
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let user = users[indexPath.row]
        cell.backgroundColor = .lighterBlue
        cell.textLabel?.text = user.username
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}
