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
    var filteredUsers = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .lighterBlue
        tableView.separatorColor = .darkerBlue
        tableView.separatorInset.left = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        let searchController = UISearchController()
    	searchController.searchResultsUpdater = self
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
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
    
    func updateSearchResults(for searchController: UISearchController) {
	    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
	        filteredUsers = users.filter { user in
	            return user.lowercased().contains(searchText.lowercased())
	        }
	        
	    } else {
	        filteredUsers = users
	    }
	    tableView.reloadData()
	}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if let searchUsers = filteredUsers {
        	let user = searchUsers[indexPath.row]
	        cell.backgroundColor = .lighterBlue
	        cell.textLabel?.text = searchUsers.username
	        cell.textLabel?.textColor = .white
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searchUsers = filteredUsers else {
        	return 0
        }
        
        return searchUsers.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}
