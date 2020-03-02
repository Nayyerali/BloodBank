//
//  NewMessagesViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 2/23/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit
import SDWebImage

class NewMessagesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var newMessageTableView: UITableView!
    
    var users =  [User]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        newMessageTableView.delegate = self
        newMessageTableView.dataSource = self
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
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewMessages") as! NewMessagesTableViewCell
        
        let user = users[indexPath.row]
        
        cell.contactUserName.text = user.firstName
        cell.contactBloodGroup.text = user.bloodGroup
        
        if let url = URL(string: user.imageUrl){
            cell.contactImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
        }
        return cell
    }
    
    var messagesController: MessagesController?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismiss(animated: true){
            let user = self.users[indexPath.row]
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let chatLogController = storyBoard.instantiateViewController(identifier: "ChatLogsViewController") as! ChatLogsViewController
            chatLogController.users = user
            self.navigationController!.pushViewController(chatLogController, animated: true)
        }
    }
}
