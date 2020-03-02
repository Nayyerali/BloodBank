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
            
            print(uid, userId)
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
//        self.messages.sort(by: { (message1, message2) -> Bool in
//
//            return message1.timestamp?.int32Value > message2.timestamp?.int32Value
//        })
        
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.chatLogsTableView.reloadData()
        })
    }
//
//    func observeUserMessages() {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//
//        print (uid)
//
//        let ref = Database.database().reference().child("user-messages").child(uid)
//        ref.observe(.childAdded, with: { (snapshot) in
//
//            let userId = snapshot.key
//            //print (userId)
//            //print(uid, userId)
//            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
//
//                let messageId = snapshot.key
//                self.fetchMessageWithMessageId(messageId)
//
//                }, withCancel: nil)
//
//            }, withCancel: nil)
//    }
//
//    fileprivate func fetchMessageWithMessageId(_ messageId: String) {
//        let messagesReference = Database.database().reference().child("Messages").child(messageId)
//
//        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
//
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                let message = MessagesClass(dictionary: dictionary)
//
//                if let chatPartnerId = message.chatPartnerId() {
//                    self.messagesDictionary[chatPartnerId] = message
//                }
//
//                self.attemptReloadOfTable()
//            }
//
//            }, withCancel: nil)
//    }
//
//    fileprivate func attemptReloadOfTable() {
//        self.timer?.invalidate()
//
//        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
//    }
//
//    var timer: Timer?
//
//    @objc func handleReloadTable() {
//        self.messages = Array(self.messagesDictionary.values)
////        self.messages.sort(by: { (message1, message2) -> Bool in
////
////            return message1.timestamp?.int32Value > message2.timestamp?.int32Value
////        })
//        self.messages.sort()
//
//        //this will crash because of background thread, so lets call this on dispatch_async main thread
//        DispatchQueue.main.async(execute: {
//            self.chatLogsTableView.reloadData()
//        })
//    }
    
    func showChatControllerForUser(_ user: User) {
        //        let chatLogController = ChatLogsViewController()
        //        chatLogController.users = user
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let chatLogController = storyBoard.instantiateViewController(identifier: "ChatLogsViewController") as! ChatLogsViewController
        chatLogController.users = user
        self.navigationController!.pushViewController(chatLogController, animated: true)
        // navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! MessagesTableViewCell
        //cell.contactUserName.text = users[indexPath.row].firstName
        cell.messageLabel.text = messages[indexPath.row].text
        if let seconds = messages[indexPath.row].timestamp {
            // if let seconds = messages.timeStamp.doubleValue {
            let timeStampDate = Date(timeIntervalSince1970: TimeInterval(seconds))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            cell.dateLabel.text = dateFormatter.string(from: timeStampDate)
            //}
        }
        if let userid = messages[indexPath.row].chatPartnerId(){
        //if let id = newMessages?.chatPartnerId(){
            
           // print (id)
          //  cell.contactUserName.text = self.users[indexPath.row].firstName
//            let new = ServerCommunication.sharedDelegate.firebaseFirestore.collection("Users").whereField("UserId", isEqualTo: userid).getDocuments { (snapshot, error) in
//
                let new = ServerCommunication.sharedDelegate.firebaseFirestore.collection("Users").getDocuments { (snapshot, error) in
//                let new = ServerCommunication.sharedDelegate.firebaseFirestore.collection("Users").getDocuments { (snapshot, error) in
//                if let dictionary = snapshot?.documents{
//                    cell.contactUserName.text = dictionary["name"] as!String
//                }
                
                if error == nil {
                    
                    if let usersData = snapshot?.documents {
                        // Got Donars
                        //                    var users:Array = [User]()
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
                            //self.users = [user]
                        }
                        //    print (user.firstName)
                        //}
                        //if let dict = snapshot?.documents as? [String:AnyObject]{
                        
                        //                        for usersData in dict {
                        //                            let data = usersData.data()
                        //                            let name = data["First Name"] as! String
                        //                            let image = data["ImageURL"] as! String
                        //
                        //                            let newData = MessagesClass.init(dictionary: dict)
                        //                            messages.append(name)
                        //                            messages.append(image)
                        //                        }
                        //cell.contactUserName.text = user.firstName
                            cell.contactUserName.text = self.users[indexPath.row].firstName
                           // cell.contactUserName.text = user.firstName
                        //dict["First Name"] as! String
                        if let url = URL(string: (self.users[indexPath.row].imageUrl)){
                            cell.contactImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
                            }
                        }
                    //}
                        //                        if let url = URL(string: (dict["ImageURL"] as! String)){
                        //                            cell.contactImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
                        //                            }
                        //                        }
                        // }
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        //            let red = ServerCommunication.sharedDelegate.firebaseFirestore.collection("Users").whereField("UserId", isEqualTo: chatPartnerId).
        let new = ServerCommunication.sharedDelegate.firebaseFirestore.collection("Users").whereField("UserId", isEqualTo: chatPartnerId).getDocuments { (snapshot, error) in
            
            if error == nil {
            
            if let usersData = snapshot?.documents {
                // Got Donars
                //                    var users:Array = [User]()
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
                
                //        let ref = Database.database().reference().child("Users").child(chatPartnerId)
                //        ref.observeSingleEvent(of: .value, with: { (snapshot) in
                //            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                //                return
                //            }
                            
                            //var user = User(userDict: dictionary)
                            //let user = User(dictionary: dictionary)
                           // user.userId = chatPartnerId
                            
                            //self.performSegue(withIdentifier: "showChatController", sender: nil)
                            
                            
                            //                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            //                let chatLogController = storyBoard.instantiateViewController(identifier: "ChatLogsViewController") as! ChatLogsViewController
                            //                chatLogController.users = user
                            //                self.navigationController!.pushViewController(chatLogController, animated: true)
                //            func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                //                if segue.identifier == "showChatController"  {
                //                    let destination = segue.destination as! ChatLogsViewController
                //                    destination.users = user
                //                }
                //            }
                        //}, withCancel: nil)
                }
            }
        }
    }
}
