//
//  NewMessagesViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 2/23/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit
import SDWebImage

class NewMessagesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var newMessageTableView: UITableView!
    @IBOutlet weak var searchUserBar: UISearchBar!
    
    
    var users =  [User]()
    var searchUser = [User]()
    var searchingUser = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        newMessageTableView.delegate = self
        newMessageTableView.dataSource = self
        searchUserBar.delegate = self
        fetchAllUsersData()
        navigationItem.title = "Contacts"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func fetchAllUsersData () {
        
        ServerCommunication.sharedDelegate.fetchAllDonarsData { (status, message, user) in
            
            if status {
                self.users = user!
                self.newMessageTableView.reloadData()
            } else {
                print ("Cound Not Load Data")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchingUser {
            return searchUser.count
        } else {
            return users.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewMessages") as! NewMessagesTableViewCell
        
        
        if searchingUser {
            cell.contactUserName.text = searchUser[indexPath.row].firstName
            cell.contactBloodGroup.text = searchUser[indexPath.row].bloodGroup
            
            if let url = URL(string: searchUser[indexPath.row].imageUrl){
                cell.contactImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
                }
            }
            
        } else {
            
            //        let user = users[indexPath.row]
            //        cell.contactUserName.text = user.firstName
            //        cell.contactBloodGroup.text = user.bloodGroup
            
            cell.contactUserName.text = users[indexPath.row].firstName
            cell.contactBloodGroup.text = users[indexPath.row].bloodGroup
            
            if let url = URL(string: users[indexPath.row].imageUrl){
                cell.contactImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
                }
            }
            
        }
        return cell
    }
    
    var messagesController: MessagesController?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchingUser {
            dismiss(animated: true){
                let user = self.searchUser[indexPath.row]
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let chatLogController = storyBoard.instantiateViewController(identifier: "ChatLogsViewController") as! ChatLogsViewController
                chatLogController.users = user
                self.navigationController!.pushViewController(chatLogController, animated: true)
            }
        } else {
            
            dismiss(animated: true){
                let user = self.users[indexPath.row]
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let chatLogController = storyBoard.instantiateViewController(identifier: "ChatLogsViewController") as! ChatLogsViewController
                chatLogController.users = user
                self.navigationController!.pushViewController(chatLogController, animated: true)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // alphabetically search Disease
        searchUser = users
        searchUser = users.filter({$0.firstName.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searchingUser = true
        newMessageTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
        searchingUser = false
        searchBar.text = "Type Name Here"
        newMessageTableView.reloadData()
    }
    
}
