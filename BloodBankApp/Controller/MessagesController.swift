//
//  ChatLogsViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 2/23/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseDatabase

class MessagesController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var messages = [MessagesClass]()
    var newMessages:MessagesClass?
    var users = [User]()
    var messagesDictionary = [String: MessagesClass]()
    
    @IBOutlet weak var chatLogsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatLogsTableView.delegate = self
        chatLogsTableView.dataSource = self
        observeUserMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
            
            //print(uid, userId)
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId)
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    fileprivate func fetchMessageWithMessageId(_ messageId: String) {
        let messagesReference = Database.database().reference().child("Messages").child(messageId)
        
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = MessagesClass(dictionary: dictionary)
                
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                self.attemptReloadOfTable()
            }
        }, withCancel: nil)
    }
    
    fileprivate func attemptReloadOfTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        messages.sort()
        
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.chatLogsTableView.reloadData()
        })
    }
    
    func showChatControllerForUser(_ user: User) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let chatLogController = storyBoard.instantiateViewController(identifier: "ChatLogsViewController") as! ChatLogsViewController
        chatLogController.users = user
        self.navigationController!.pushViewController(chatLogController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! MessagesTableViewCell
        //cell.contactUserName.text = users[indexPath.row].firstName
        cell.messageLabel.text = messages[indexPath.row].text
        if let seconds = messages[indexPath.row].timestamp {
            let timeStampDate = Date(timeIntervalSince1970: TimeInterval(seconds))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            cell.dateLabel.text = dateFormatter.string(from: timeStampDate)
        }
        
        if let userid = messages[indexPath.row].chatPartnerId(){
            
            let new = ServerCommunication.sharedDelegate.firebaseFirestore.collection("Users").whereField("UserId", isEqualTo: userid).getDocuments { (snapshot, error) in
                
                if error == nil {
                    
                    if let usersData = snapshot?.documents {

                        for matchingUser in usersData {
                            let usersDocuments = matchingUser.data()
                            let firstName = usersDocuments["First Name"] as! String
                            let bloodGroup = usersDocuments["BloodGroup"] as! String
                            let imageUrl = usersDocuments["ImageURL"] as! String
                            let userId = usersDocuments["UserId"] as! String
                            let lastName = usersDocuments["LastName"] as! String
                            let email = usersDocuments["Email"] as! String
                            let dateOfBirth = usersDocuments["DateOfBirth"] as! String
                            let phoneNumber = usersDocuments["PhoneNumber"] as! String
                            
                            let user = User(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, bloodGroup: bloodGroup, phoneNumber: phoneNumber, email: email, userId: userId, imageUrl: imageUrl)
                            
                            self.users.append(user)
                            self.chatLogsTableView.reloadData()
                            cell.contactUserName.text = user.firstName
                            
                            if let url = URL(string: (user.imageUrl)){
                                cell.contactImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
                                }
                            }
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.showAlert(controller: self, title: "Delete Messages", message: "Do you really want to delete this Message?", actiontitle: "Delete") { (isDelete) in
                if isDelete{
                    let ref = Database.database().reference().child("user-messages").child(User.userSharefReference.userId).child(self.messages[indexPath.row].toId!).removeValue()
                    let refrence2 = Database.database().reference().child("Messages").child(User.userSharefReference.userId).removeValue()
                    self.showAlert(controller: self, title: "Success", message: "Chat Deleted Successfully") { (Ok) in
                        
                        self.messages.remove(at: indexPath.row)
                        self.chatLogsTableView.reloadData()
                    }
                } else {
                    self.showAlert(controller: self, title: "Failed", message: "Could Not Delete Chat") { (Ok) in
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let new = ServerCommunication.sharedDelegate.firebaseFirestore.collection("Users").whereField("UserId", isEqualTo: chatPartnerId).getDocuments { (snapshot, error) in
            
            if error == nil {
                
                if let usersData = snapshot?.documents {
                    // Got Donars
                    for matchingUser in usersData {
                        let usersDocuments = matchingUser.data()
                        let firstName = usersDocuments["First Name"] as! String
                        let bloodGroup = usersDocuments["BloodGroup"] as! String
                        let imageUrl = usersDocuments["ImageURL"] as! String
                        let userId = usersDocuments["UserId"] as! String
                        let lastName = usersDocuments["LastName"] as! String
                        let email = usersDocuments["Email"] as! String
                        let dateOfBirth = usersDocuments["DateOfBirth"] as! String
                        let phoneNumber = usersDocuments["PhoneNumber"] as! String
                        
                        let user = User(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, bloodGroup: bloodGroup, phoneNumber: phoneNumber, email: email, userId: userId, imageUrl: imageUrl)
                        
                        self.users.append(user)
                        self.showChatControllerForUser(user)
                    }
                }
            }
        }
    }
    
    func showAlert(controller:UIViewController,title:String,message:String,completion:@escaping(_ okBtnPressed:Bool)->Void){
        let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            // ok button press
            completion(true)
        }
        alerController.addAction(okAction)
        controller.present(alerController, animated: true)
    }
    
    func showAlert(controller:UIViewController,title:String,message:String,actiontitle:String,completion:@escaping(_ okBtnPressed:Bool)->Void){
        let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let delete = UIAlertAction(title: actiontitle, style: .destructive) { (alertAction) in
            // ok button press
            completion(true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in
            // ok button press
            completion(false)
        }
        alerController.addAction(delete)
        alerController.addAction(cancel)
        controller.present(alerController, animated: true)
    }
}
